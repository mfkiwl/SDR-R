/* sdrdriver.c
 *
 * Main Driver code for our SDR platform. Will mainly serve two functions:
 *
 *    1. Stream data from from FPGA to a local software FIFO. 
 *       This FIFO will be a linux "Named Pipe" and GNU Radio
 *       will be reading from this pipe.
 *    2. Send instructional bytes to FPGA to essentially tune
 *       to a particular frequency. 
 *
 *  Effective flow of the program will be as follows:
 *    
 *     1. Set up FTDI device
 *     2. Prompt User for demod scheme and carrier freq if applicable
 *     3. Send info to FPGA via FTDI
 *     4. Fork process or create thread
 *       a. Parent: start flowgraph & fork child
 *       b. Child:  start read stream from FTDI
 *     5. Data is streaming
 *       a. Parent: wait for child to finish
 *       b. Child:  stream stuff... eventually stream will close
 *     6. Stream has ended
 *       a. Parent: terminate when child is done
 *       b. Child:  done.
 *
 ****
 */
#define _POSIX_SOURCE
#include <signal.h> // For signal handler

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <signal.h>
#include <errno.h>
#include <libftdi1/ftdi.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <stdint.h>
#include <math.h>

// NOTE Refer to OS class hw3 for examples of producer/consumer threads


////////////////////////////////////////
// GLOBAL VARIABLES ////////////////////
////////////////////////////////////////
static int exittrigger = 0;
static int cleanupflag = 0;
char * PIPEPATH = "/tmp/iqpipe";
static FILE *outputFile;


////////////////////////////////////////
// Signal Handler //////////////////////
////////////////////////////////////////
static void signalhandler (int signum) {
    printf("\nExit Requested via Signal %d\n", signum);
    exittrigger = 1;
}

////////////////////////////////////////
// FTDI Callbacks //////////////////////
////////////////////////////////////////
static int readCallback(uint8_t *buffer, int length, 
        FTDIProgressInfo *progress, void * userdata) {
    static uint8_t latch = 0;
    if (length) {
        if (outputFile && !cleanupflag) {
            if (fwrite(buffer, length, 1, outputFile) != 1) {
                perror("ReadCallback:\tWrite Error\n");
                return 1;
            }
        }
        else if (!latch){
            latch = 1;
            fprintf(stderr,"\n\n\nreadcallback:\tCleanup Thread Detected. Ceasing Write\n");
            goto callbackexit;
        }
        else
            goto callbackexit;
    }
    if (progress) {
        fprintf(stderr, "%10.02fs elapsed %9.3f MiB captured %7.1f kB/s curr rate %7.1f kB/s totalrate\n",
                progress->totalTime,
                progress->current.totalBytes / (1024.0 * 1024.0),
                progress->currentRate / 1024.0,
                progress->totalRate / 1024.0);
    }
callbackexit:
    return exittrigger ? 1 : 0;
}

////////////////////////////////////////
// Child Threads ///////////////////////
////////////////////////////////////////

static void * cleanupthread(void * args) {
    uint8_t * buf[1024];
    size_t retval = 0;
    cleanupflag = 1;
    fprintf(stderr,"CleanupThread:\tStarting cleanup\n");
    if (fopen(PIPEPATH,"r") == 0) {
        fprintf(stderr,"CleanupThread:\tError Occured in Cleanup\n");
    }
    while (retval < 1024) {
        retval = fread(buf,1,1024,outputFile);
        if (retval == 0) {
            fprintf(stderr,"CleanupThread:\tiqpipe purged\n");
            break;
        }
        fprintf(stderr,"CleanupThread:\tPurged %lu bytes\n",retval);
    }
    fprintf(stderr,"CleanupThread:\t Cleanup Complete! Exiting\n");
    return NULL;
}

static void * pythread(void * args) {
    int retval;
    pthread_t cleanuptid;
    printf("PyCHILD:\t**I'm child thread\n");
    retval = system("./top_block.py");
    printf("PyCHILD:\t**GNURadio terminated with retval = %d\n",retval);
    raise(SIGINT);

    retval = pthread_create(&cleanuptid, NULL, cleanupthread,NULL);
    if (retval != 0) {
        fprintf(stderr,"MAIN:\tAn error occured spawning cleanup thread!\n");
        return NULL;
    }
    printf("PyCHILD:\t**Waiting for cleanup thread...\n");
    retval = pthread_join(cleanuptid,NULL);
    if (retval != 0) {
        fprintf(stderr,"MAIN:\tError on joining cleanup thread with pythread\n");
    }
    printf("PyCHILD:\t**Cleanup thread joined w/ Python thread\n");
    printf("PyCHILD:\t**Python Thread exiting...\n");

    return NULL;
}


////////////////////////////////////////
// Utility Function ////////////////////
////////////////////////////////////////
//
uint32_t getfreq(){
    uint32_t topmask    = 0xFFC00000;
    uint32_t bottommask = 0x003FFFFF;
    int  bigfreq = 400000000; // 400 MHz
    int  usrfreq;

    // Take in user input
    printf("Enter Frequency in Hz: ");
    scanf("%d",&usrfreq);
    printf("Received: %.2f kHz\n",(float) usrfreq/1000);


    // Get Quotient and Remainder
    div_t res = div(bigfreq,usrfreq);     // Retval is a struct div_t

    // Quotient is top 10 bits
    uint32_t top = (uint32_t) (res.quot); // top is integer portion
    top = (top << 22) & topmask;          // Shift and apply mask, probz unnecessary

    // Fractional remainder is bottom 22 bits
    float frac = (float) res.rem/usrfreq; // Get fractional portion
    frac *= powf(2,22);                   // Scale by 2^22
    uint32_t bottom = (uint32_t) frac;    // Save as uint32_t
    bottom &= bottommask;                 // apply mask... probz unnecessary


    uint32_t message = top | bottom;

    return message;
}


////////////////////////////////////////
// Main Thread /////////////////////////
////////////////////////////////////////
int main (int argc, char **argv) {
    ////////////////////////////////////////
    // Signal Handler Setup ////////////////
    ////////////////////////////////////////
    sigset_t mask;
    sigemptyset(&mask); // Initializes empty mask, includes NO signals 
    struct sigaction sa = {
        .sa_handler = signalhandler,
        .sa_mask    = mask,
        .sa_flags   = 0
    };
    sigaction(SIGINT, &sa, NULL); // Associates SIGINT w/ signalhandler



    ////////////////////////////////////////
    // Start of Program ////////////////////
    ////////////////////////////////////////
    int retval;
    pthread_t tid1;

    uint8_t usrfrq [4];
    uint8_t buf [4];

    printf("MAIN:\tSETTING UP FTDI DEVICE\n");
    struct ftdi_context *ftdi;
    char *descstring = 0;

    if ((ftdi = ftdi_new()) == 0) {
        fprintf(stderr,"MAIN:\tftdi_new failed\n");
        goto fail;
    }
    printf("MAIN:\tSuccessfully Allocated and Initialized new ftdi_context\n");

    if (ftdi_set_interface(ftdi,INTERFACE_A) < 0) {
        fprintf(stderr, "MAIN:\tftdi_set_interface failed\n");
        ftdi_free(ftdi);
        goto fail;
    }
    printf("MAIN:\tSuccessfully set interface to Channel A\n");


    if (ftdi_usb_open_desc(ftdi, 0x0403, 0x6014, descstring, NULL) < 0) {
        fprintf(stderr,"MAIN:\tCan't open ftdi device: %s\n", ftdi_get_error_string(ftdi));
        ftdi_free(ftdi);
        goto fail;
    }
    printf("MAIN:\tSuccessfully opened FTDI device, VendorID: 0x0403, ProductID: 0x6014\n");


    if (ftdi_set_latency_timer(ftdi, 2)) {
        fprintf(stderr,"MAIN:\tCan't set latency, Error %s\n",ftdi_get_error_string(ftdi));
        ftdi_usb_close(ftdi);
        ftdi_free(ftdi);
        goto fail;
    }
    printf("MAIN:\tSuccessfully set latency timer to mandatory 2\n");

    // May cause issues, delete as needed
    printf("Clearing FTDI TX/RX Buffers\n");
    if (ftdi_usb_purge_buffers(ftdi) < 0) {
        fprintf(stderr,"MAIN:\tCan't purge ftdi tx/rx %s\n",ftdi_get_error_string(ftdi));
        ftdi_free(ftdi);
        goto fail;
    }
    printf("MAIN:\tSuccessfully cleared FTDI TX/RX Buffers\n\n");

    printf("MAIN:\tSetting bitmode to SYNCFF...\n");
    if (ftdi_set_bitmode(ftdi,  0xff, BITMODE_SYNCFF) < 0) {
        fprintf(stderr,"Can't set synchronous fifo mode, Error %s\n",
               ftdi_get_error_string(ftdi));
        ftdi_usb_close(ftdi);
        ftdi_free(ftdi);
        goto fail;
    }
    printf("MAIN:\tSuccessfully set bitmode to SYNCFF\n");
    printf("MAIN:\tFTDI GOOD TO GO!\n");

    //////////////////////////////////////// FINAL STEP FOR SUCCESS!!!!
    printf("MAIN:\t GET CARRIER FREQ, SEND TO FTDI CHIP\n");
    *(uint32_t *) buf = getfreq(); // casting uint32_t to byte array
    usrfrq[3] = buf[0];
    usrfrq[2] = buf[1];
    usrfrq[1] = buf[2];
    usrfrq[0] = buf[3];
    printf("MAIN:\tSanity Check!! usrfrq = 0x%02X%02X%02X%02X\n",usrfrq[0],
                                                                 usrfrq[1],
                                                                 usrfrq[2],
                                                                 usrfrq[3]);

    printf("MAIN:\tSending 4 bytes to FPGA\n");
    retval = ftdi_write_data(ftdi,usrfrq,4);
    if (retval != 4) {
        fprintf(stderr,"ERROR:\t Only wrote %d bytes\n",retval);
        ftdi_usb_close(ftdi);
        ftdi_free(ftdi);
        goto fail;
    }
    printf("MAIN:\t Message successfully sent to FPGA!\n");
    // Following refers to Debug Pins on FPGA, Pins are 39-49 or so. Check FPGA xdc constraints file
    printf("DEBUG:\t\t Check top 8 for 0x%02X\n\t\tCheck bottom 2 for 0x%02X\n",usrfrq[0],(usrfrq[1] >> 6));
    printf("DEBUG:\t\tPress Enter to resume\n");
    getchar();
    getchar();
    //////////////////////////////////// END FINAL STEP FOR SUCCESS!!!!
    
    // Create named pipe for FTDI data to be stored
    printf("MAIN:\tCreating FIFO at %s\n",PIPEPATH);
    mkfifo(PIPEPATH,0666);
    printf("MAIN:\tOpening FIFO...\n");
    
    // Alternate way of opening iqpipe
    if ((outputFile = fopen(PIPEPATH,"w+")) == 0) {
        fprintf(stderr,"MAIN:\tCan't open iqpipe %s, Error %s\n",PIPEPATH,
                                                                 strerror(errno));
    }
    
    printf("MAIN:\tFIFO Opened!\n");
    printf("MAIN:\tNOW THAT FIFO IS OPEN, START THREAD THAT OPENS OTHER END\n");

    printf("MAIN:\tCreating child thread...\n");
    retval = pthread_create(&tid1,NULL,pythread,NULL);
    if (retval != 0) {
        fprintf(stderr,"MAIN:\tAn error occured spawning child thread!\n");
        goto fail1;
    }
    printf("MAIN:\tPython child thread started!\n");
    printf("Read stream will follow\n");

   retval = ftdi_readstream(ftdi, readCallback, NULL, 8, 256);
   if (retval < 0 && !exittrigger) {
       fprintf(stderr,"MAIN:\tAn error occured in read callback\n");
       ftdi_usb_close(ftdi);
       ftdi_free(ftdi);
       goto fail;
   }
   fprintf(stderr,"MAIN:\tCapture ended\n");

    printf("MAIN:\tWaiting for Python Thread...\n");
    retval = pthread_join(tid1,NULL);
    if (retval != 0) {
        fprintf(stderr,"MAIN:\tError on joining python thread with main\n");
        goto fail1;
    }
    printf("MAIN:\tPython thread joined!\n");
      
    // Close file
    if (fclose(outputFile)){
    //if (close(filedesc)) {
        fprintf(stderr,"MAIN:\tError occured closing file\n");
        goto fail;
    }
    // Remove FIFO
    printf("MAIN:\tRemoving FIFO at %s\n",PIPEPATH);
    if (remove(PIPEPATH)) {
        fprintf(stderr,"MAIN:\tError removing FIFO at %s\n",PIPEPATH);
        goto fail;
    }
    printf("MAIN:\tSuccessfuly removed FIFO\n");
    // Clear up FTDI context
    printf("MAIN:\tResetting FTDI chip mode\n");
      
   if (ftdi_set_bitmode(ftdi,  0xff, BITMODE_RESET) < 0)
   {
       fprintf(stderr,"Can't reset mode, Error %s\n",ftdi_get_error_string(ftdi));
       ftdi_usb_close(ftdi);
       ftdi_free(ftdi);
       goto fail;
   }  
    ftdi_usb_close(ftdi);
    ftdi_free(ftdi);
    return EXIT_SUCCESS;

fail1: // error creating thread, close file, and remove FIFO
    // Close file
    if (outputFile) {
        fclose(outputFile);
        outputFile = NULL;
    }

    // Remove FIFO
    printf("MAIN:\tRemoving FIFO at %s\n",PIPEPATH);
    if (remove(PIPEPATH)) {
        fprintf(stderr,"MAIN:\tError removing FIFO at %s\n",PIPEPATH);
        goto fail;
    }
    printf("MAIN:\tSuccessfuly removed FIFO\n");

fail:
    return EXIT_FAILURE;
}
