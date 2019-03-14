#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Wed Mar 13 21:33:09 2019
##################################################

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print "Warning: failed to XInitThreads()"

from PyQt4 import Qt
from gnuradio import analog
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import filter
from gnuradio import gr
from gnuradio import qtgui
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from gnuradio.qtgui import Range, RangeWidget
from grc_gnuradio import blks2 as grc_blks2
from optparse import OptionParser
import sip
import sys


class top_block(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "Top Block")
        Qt.QWidget.__init__(self)
        self.setWindowTitle("Top Block")
        try:
            self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
        except:
            pass
        self.top_scroll_layout = Qt.QVBoxLayout()
        self.setLayout(self.top_scroll_layout)
        self.top_scroll = Qt.QScrollArea()
        self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
        self.top_scroll_layout.addWidget(self.top_scroll)
        self.top_scroll.setWidgetResizable(True)
        self.top_widget = Qt.QWidget()
        self.top_scroll.setWidget(self.top_widget)
        self.top_layout = Qt.QVBoxLayout(self.top_widget)
        self.top_grid_layout = Qt.QGridLayout()
        self.top_layout.addLayout(self.top_grid_layout)

        self.settings = Qt.QSettings("GNU Radio", "top_block")
        self.restoreGeometry(self.settings.value("geometry").toByteArray())

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 20e3
        self.noise_switch = noise_switch = False
        self.freq_sine = freq_sine = 50
        self.fil_switch = fil_switch = True
        self.center_freq_filter = center_freq_filter = 5e3
        self.carrier_freq = carrier_freq = 500e3
        self.carrier_amp = carrier_amp = 1

        ##################################################
        # Blocks
        ##################################################
        _noise_switch_check_box = Qt.QCheckBox('Artificial Noise On/Off')
        self._noise_switch_choices = {True: True, False: False}
        self._noise_switch_choices_inv = dict((v,k) for k,v in self._noise_switch_choices.iteritems())
        self._noise_switch_callback = lambda i: Qt.QMetaObject.invokeMethod(_noise_switch_check_box, "setChecked", Qt.Q_ARG("bool", self._noise_switch_choices_inv[i]))
        self._noise_switch_callback(self.noise_switch)
        _noise_switch_check_box.stateChanged.connect(lambda i: self.set_noise_switch(self._noise_switch_choices[bool(i)]))
        self.top_grid_layout.addWidget(_noise_switch_check_box, 3,1)
        self._freq_sine_range = Range(50, 10e3, 1, 50, 200)
        self._freq_sine_win = RangeWidget(self._freq_sine_range, self.set_freq_sine, 'Input Signal Frequency', "counter_slider", float)
        self.top_grid_layout.addWidget(self._freq_sine_win, 3,0)
        _fil_switch_check_box = Qt.QCheckBox('Filter On/Off')
        self._fil_switch_choices = {True: True, False: False}
        self._fil_switch_choices_inv = dict((v,k) for k,v in self._fil_switch_choices.iteritems())
        self._fil_switch_callback = lambda i: Qt.QMetaObject.invokeMethod(_fil_switch_check_box, "setChecked", Qt.Q_ARG("bool", self._fil_switch_choices_inv[i]))
        self._fil_switch_callback(self.fil_switch)
        _fil_switch_check_box.stateChanged.connect(lambda i: self.set_fil_switch(self._fil_switch_choices[bool(i)]))
        self.top_grid_layout.addWidget(_fil_switch_check_box, 2,1)
        self._center_freq_filter_range = Range(1e3, 9e3, 10, 5e3, 200)
        self._center_freq_filter_win = RangeWidget(self._center_freq_filter_range, self.set_center_freq_filter, 'Cut Off Frequency for Filter', "counter_slider", float)
        self.top_grid_layout.addWidget(self._center_freq_filter_win, 2,0)
        self._carrier_freq_range = Range(50, 5e6, 10, 500e3, 200)
        self._carrier_freq_win = RangeWidget(self._carrier_freq_range, self.set_carrier_freq, 'Carrier Frequency', "counter_slider", float)
        self.top_grid_layout.addWidget(self._carrier_freq_win, 4,0)
        self._carrier_amp_range = Range(1, 10, 1, 1, 200)
        self._carrier_amp_win = RangeWidget(self._carrier_amp_range, self.set_carrier_amp, 'Carrier Amplitude', "counter_slider", float)
        self.top_grid_layout.addWidget(self._carrier_amp_win, 4,1)
        self.quadrature_osc = analog.sig_source_f(samp_rate, analog.GR_SIN_WAVE, carrier_freq, 5, 0)
        self.qtgui_waterfall_sink_x_0 = qtgui.waterfall_sink_c(
        	2048, #size
        	firdes.WIN_BLACKMAN_hARRIS, #wintype
        	0, #fc
        	samp_rate, #bw
        	"Waterfall Plot", #name
                1 #number of inputs
        )
        self.qtgui_waterfall_sink_x_0.set_update_time(0.10)
        self.qtgui_waterfall_sink_x_0.enable_grid(False)
        self.qtgui_waterfall_sink_x_0.enable_axis_labels(True)
        
        if not False:
          self.qtgui_waterfall_sink_x_0.disable_legend()
        
        if "complex" == "float" or "complex" == "msg_float":
          self.qtgui_waterfall_sink_x_0.set_plot_pos_half(not True)
        
        labels = ['', '', '', '', '',
                  '', '', '', '', '']
        colors = [1, 0, 0, 0, 0,
                  0, 0, 0, 0, 0]
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0, 1.0, 1.0]
        for i in xrange(1):
            if len(labels[i]) == 0:
                self.qtgui_waterfall_sink_x_0.set_line_label(i, "Data {0}".format(i))
            else:
                self.qtgui_waterfall_sink_x_0.set_line_label(i, labels[i])
            self.qtgui_waterfall_sink_x_0.set_color_map(i, colors[i])
            self.qtgui_waterfall_sink_x_0.set_line_alpha(i, alphas[i])
        
        self.qtgui_waterfall_sink_x_0.set_intensity_range(-140, 10)
        
        self._qtgui_waterfall_sink_x_0_win = sip.wrapinstance(self.qtgui_waterfall_sink_x_0.pyqwidget(), Qt.QWidget)
        self.top_grid_layout.addWidget(self._qtgui_waterfall_sink_x_0_win, 1,1)
        self.qtgui_time_sink_x_1 = qtgui.time_sink_f(
        	1024, #size
        	samp_rate, #samp_rate
        	"Modulated Signal", #name
        	1 #number of inputs
        )
        self.qtgui_time_sink_x_1.set_update_time(0.10)
        self.qtgui_time_sink_x_1.set_y_axis(0, 50)
        
        self.qtgui_time_sink_x_1.set_y_label('Amplitude', "")
        
        self.qtgui_time_sink_x_1.enable_tags(-1, True)
        self.qtgui_time_sink_x_1.set_trigger_mode(qtgui.TRIG_MODE_FREE, qtgui.TRIG_SLOPE_POS, 0.0, 0, 0, "")
        self.qtgui_time_sink_x_1.enable_autoscale(True)
        self.qtgui_time_sink_x_1.enable_grid(False)
        self.qtgui_time_sink_x_1.enable_axis_labels(True)
        self.qtgui_time_sink_x_1.enable_control_panel(False)
        
        if not False:
          self.qtgui_time_sink_x_1.disable_legend()
        
        labels = ['', '', '', '', '',
                  '', '', '', '', '']
        widths = [1, 1, 1, 1, 1,
                  1, 1, 1, 1, 1]
        colors = ["blue", "red", "green", "black", "cyan",
                  "magenta", "yellow", "dark red", "dark green", "blue"]
        styles = [1, 1, 1, 1, 1,
                  1, 1, 1, 1, 1]
        markers = [-1, -1, -1, -1, -1,
                   -1, -1, -1, -1, -1]
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0, 1.0, 1.0]
        
        for i in xrange(1):
            if len(labels[i]) == 0:
                self.qtgui_time_sink_x_1.set_line_label(i, "Data {0}".format(i))
            else:
                self.qtgui_time_sink_x_1.set_line_label(i, labels[i])
            self.qtgui_time_sink_x_1.set_line_width(i, widths[i])
            self.qtgui_time_sink_x_1.set_line_color(i, colors[i])
            self.qtgui_time_sink_x_1.set_line_style(i, styles[i])
            self.qtgui_time_sink_x_1.set_line_marker(i, markers[i])
            self.qtgui_time_sink_x_1.set_line_alpha(i, alphas[i])
        
        self._qtgui_time_sink_x_1_win = sip.wrapinstance(self.qtgui_time_sink_x_1.pyqwidget(), Qt.QWidget)
        self.top_grid_layout.addWidget(self._qtgui_time_sink_x_1_win, 0,0)
        self.qtgui_time_sink_x_0 = qtgui.time_sink_f(
        	1024, #size
        	samp_rate, #samp_rate
        	"Input Signal and |I + jQ| Plot", #name
        	2 #number of inputs
        )
        self.qtgui_time_sink_x_0.set_update_time(0.10)
        self.qtgui_time_sink_x_0.set_y_axis(0, 50)
        
        self.qtgui_time_sink_x_0.set_y_label('Amplitude', "")
        
        self.qtgui_time_sink_x_0.enable_tags(-1, True)
        self.qtgui_time_sink_x_0.set_trigger_mode(qtgui.TRIG_MODE_FREE, qtgui.TRIG_SLOPE_POS, 0.0, 0, 0, "")
        self.qtgui_time_sink_x_0.enable_autoscale(True)
        self.qtgui_time_sink_x_0.enable_grid(False)
        self.qtgui_time_sink_x_0.enable_axis_labels(True)
        self.qtgui_time_sink_x_0.enable_control_panel(False)
        
        if not False:
          self.qtgui_time_sink_x_0.disable_legend()
        
        labels = ['Signal (Pre-Modulation)', '|I+jQ|', '', '', '',
                  '', '', '', '', '']
        widths = [1, 1, 1, 1, 1,
                  1, 1, 1, 1, 1]
        colors = ["blue", "red", "green", "black", "cyan",
                  "magenta", "yellow", "dark red", "dark green", "blue"]
        styles = [1, 1, 1, 1, 1,
                  1, 1, 1, 1, 1]
        markers = [-1, -1, -1, -1, -1,
                   -1, -1, -1, -1, -1]
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0, 1.0, 1.0]
        
        for i in xrange(2):
            if len(labels[i]) == 0:
                self.qtgui_time_sink_x_0.set_line_label(i, "Data {0}".format(i))
            else:
                self.qtgui_time_sink_x_0.set_line_label(i, labels[i])
            self.qtgui_time_sink_x_0.set_line_width(i, widths[i])
            self.qtgui_time_sink_x_0.set_line_color(i, colors[i])
            self.qtgui_time_sink_x_0.set_line_style(i, styles[i])
            self.qtgui_time_sink_x_0.set_line_marker(i, markers[i])
            self.qtgui_time_sink_x_0.set_line_alpha(i, alphas[i])
        
        self._qtgui_time_sink_x_0_win = sip.wrapinstance(self.qtgui_time_sink_x_0.pyqwidget(), Qt.QWidget)
        self.top_grid_layout.addWidget(self._qtgui_time_sink_x_0_win, 1,0)
        self.qtgui_freq_sink_x_0 = qtgui.freq_sink_c(
        	2048, #size
        	firdes.WIN_BLACKMAN_hARRIS, #wintype
        	0, #fc
        	samp_rate, #bw
        	"Frequency Spectrum", #name
        	1 #number of inputs
        )
        self.qtgui_freq_sink_x_0.set_update_time(0.10)
        self.qtgui_freq_sink_x_0.set_y_axis(-140, 10)
        self.qtgui_freq_sink_x_0.set_y_label('Relative Gain', 'dB')
        self.qtgui_freq_sink_x_0.set_trigger_mode(qtgui.TRIG_MODE_FREE, 0.0, 0, "")
        self.qtgui_freq_sink_x_0.enable_autoscale(False)
        self.qtgui_freq_sink_x_0.enable_grid(False)
        self.qtgui_freq_sink_x_0.set_fft_average(1.0)
        self.qtgui_freq_sink_x_0.enable_axis_labels(True)
        self.qtgui_freq_sink_x_0.enable_control_panel(False)
        
        if not False:
          self.qtgui_freq_sink_x_0.disable_legend()
        
        if "complex" == "float" or "complex" == "msg_float":
          self.qtgui_freq_sink_x_0.set_plot_pos_half(not True)
        
        labels = ['', '', '', '', '',
                  '', '', '', '', '']
        widths = [1, 1, 1, 1, 1,
                  1, 1, 1, 1, 1]
        colors = ["blue", "red", "green", "black", "cyan",
                  "magenta", "yellow", "dark red", "dark green", "dark blue"]
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0, 1.0, 1.0]
        for i in xrange(1):
            if len(labels[i]) == 0:
                self.qtgui_freq_sink_x_0.set_line_label(i, "Data {0}".format(i))
            else:
                self.qtgui_freq_sink_x_0.set_line_label(i, labels[i])
            self.qtgui_freq_sink_x_0.set_line_width(i, widths[i])
            self.qtgui_freq_sink_x_0.set_line_color(i, colors[i])
            self.qtgui_freq_sink_x_0.set_line_alpha(i, alphas[i])
        
        self._qtgui_freq_sink_x_0_win = sip.wrapinstance(self.qtgui_freq_sink_x_0.pyqwidget(), Qt.QWidget)
        self.top_grid_layout.addWidget(self._qtgui_freq_sink_x_0_win, 0,1)
        self.low_pass_filter_0 = filter.fir_filter_ccf(1, firdes.low_pass(
        	1, samp_rate, center_freq_filter, 10, firdes.WIN_HAMMING, 6.76))
        self.inphase_osc = analog.sig_source_f(samp_rate, analog.GR_COS_WAVE, carrier_freq, 5, 0)
        self.blocks_throttle_0_0 = blocks.throttle(gr.sizeof_float*1, samp_rate,True)
        self.blocks_throttle_0 = blocks.throttle(gr.sizeof_gr_complex*1, samp_rate,True)
        self.blocks_multiply_xx_0_1 = blocks.multiply_vff(1)
        self.blocks_multiply_xx_0_0 = blocks.multiply_vff(1)
        self.blocks_multiply_xx_0 = blocks.multiply_vff(1)
        self.blocks_float_to_complex_0 = blocks.float_to_complex(1)
        self.blocks_complex_to_mag_0 = blocks.complex_to_mag(1)
        self.blocks_add_xx_0 = blocks.add_vff(1)
        self.blocks_add_const_vxx_0 = blocks.add_const_vff((5, ))
        self.blks2_selector_0_0 = grc_blks2.selector(
        	item_size=gr.sizeof_gr_complex*1,
        	num_inputs=2,
        	num_outputs=1,
        	input_index=fil_switch,
        	output_index=0,
        )
        self.blks2_selector_0 = grc_blks2.selector(
        	item_size=gr.sizeof_gr_complex*1,
        	num_inputs=1,
        	num_outputs=2,
        	input_index=0,
        	output_index=fil_switch,
        )
        self.analog_sig_source_x_0_0 = analog.sig_source_f(samp_rate, analog.GR_COS_WAVE, carrier_freq, carrier_amp, 0)
        self.analog_sig_source_x_0 = analog.sig_source_f(samp_rate, analog.GR_COS_WAVE, freq_sine, 5, 0)
        self.analog_noise_source_x_0 = analog.noise_source_f(analog.GR_GAUSSIAN, noise_switch, 0)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_noise_source_x_0, 0), (self.blocks_add_xx_0, 1))    
        self.connect((self.analog_sig_source_x_0, 0), (self.blocks_add_xx_0, 0))    
        self.connect((self.analog_sig_source_x_0_0, 0), (self.blocks_multiply_xx_0, 1))    
        self.connect((self.blks2_selector_0, 0), (self.blks2_selector_0_0, 0))    
        self.connect((self.blks2_selector_0, 1), (self.low_pass_filter_0, 0))    
        self.connect((self.blks2_selector_0_0, 0), (self.blocks_throttle_0, 0))    
        self.connect((self.blocks_add_const_vxx_0, 0), (self.blocks_multiply_xx_0, 0))    
        self.connect((self.blocks_add_const_vxx_0, 0), (self.blocks_throttle_0_0, 0))    
        self.connect((self.blocks_add_xx_0, 0), (self.blocks_add_const_vxx_0, 0))    
        self.connect((self.blocks_complex_to_mag_0, 0), (self.qtgui_time_sink_x_0, 1))    
        self.connect((self.blocks_float_to_complex_0, 0), (self.blks2_selector_0, 0))    
        self.connect((self.blocks_multiply_xx_0, 0), (self.blocks_multiply_xx_0_0, 0))    
        self.connect((self.blocks_multiply_xx_0, 0), (self.blocks_multiply_xx_0_1, 0))    
        self.connect((self.blocks_multiply_xx_0, 0), (self.qtgui_time_sink_x_1, 0))    
        self.connect((self.blocks_multiply_xx_0_0, 0), (self.blocks_float_to_complex_0, 0))    
        self.connect((self.blocks_multiply_xx_0_1, 0), (self.blocks_float_to_complex_0, 1))    
        self.connect((self.blocks_throttle_0, 0), (self.blocks_complex_to_mag_0, 0))    
        self.connect((self.blocks_throttle_0, 0), (self.qtgui_freq_sink_x_0, 0))    
        self.connect((self.blocks_throttle_0, 0), (self.qtgui_waterfall_sink_x_0, 0))    
        self.connect((self.blocks_throttle_0_0, 0), (self.qtgui_time_sink_x_0, 0))    
        self.connect((self.inphase_osc, 0), (self.blocks_multiply_xx_0_0, 1))    
        self.connect((self.low_pass_filter_0, 0), (self.blks2_selector_0_0, 1))    
        self.connect((self.quadrature_osc, 0), (self.blocks_multiply_xx_0_1, 1))    

    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "top_block")
        self.settings.setValue("geometry", self.saveGeometry())
        event.accept()

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.quadrature_osc.set_sampling_freq(self.samp_rate)
        self.qtgui_waterfall_sink_x_0.set_frequency_range(0, self.samp_rate)
        self.qtgui_time_sink_x_1.set_samp_rate(self.samp_rate)
        self.qtgui_time_sink_x_0.set_samp_rate(self.samp_rate)
        self.qtgui_freq_sink_x_0.set_frequency_range(0, self.samp_rate)
        self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, self.center_freq_filter, 10, firdes.WIN_HAMMING, 6.76))
        self.inphase_osc.set_sampling_freq(self.samp_rate)
        self.blocks_throttle_0_0.set_sample_rate(self.samp_rate)
        self.blocks_throttle_0.set_sample_rate(self.samp_rate)
        self.analog_sig_source_x_0_0.set_sampling_freq(self.samp_rate)
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)

    def get_noise_switch(self):
        return self.noise_switch

    def set_noise_switch(self, noise_switch):
        self.noise_switch = noise_switch
        self._noise_switch_callback(self.noise_switch)
        self.analog_noise_source_x_0.set_amplitude(self.noise_switch)

    def get_freq_sine(self):
        return self.freq_sine

    def set_freq_sine(self, freq_sine):
        self.freq_sine = freq_sine
        self.analog_sig_source_x_0.set_frequency(self.freq_sine)

    def get_fil_switch(self):
        return self.fil_switch

    def set_fil_switch(self, fil_switch):
        self.fil_switch = fil_switch
        self._fil_switch_callback(self.fil_switch)
        self.blks2_selector_0_0.set_input_index(int(self.fil_switch))
        self.blks2_selector_0.set_output_index(int(self.fil_switch))

    def get_center_freq_filter(self):
        return self.center_freq_filter

    def set_center_freq_filter(self, center_freq_filter):
        self.center_freq_filter = center_freq_filter
        self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, self.center_freq_filter, 10, firdes.WIN_HAMMING, 6.76))

    def get_carrier_freq(self):
        return self.carrier_freq

    def set_carrier_freq(self, carrier_freq):
        self.carrier_freq = carrier_freq
        self.quadrature_osc.set_frequency(self.carrier_freq)
        self.inphase_osc.set_frequency(self.carrier_freq)
        self.analog_sig_source_x_0_0.set_frequency(self.carrier_freq)

    def get_carrier_amp(self):
        return self.carrier_amp

    def set_carrier_amp(self, carrier_amp):
        self.carrier_amp = carrier_amp
        self.analog_sig_source_x_0_0.set_amplitude(self.carrier_amp)


def main(top_block_cls=top_block, options=None):

    from distutils.version import StrictVersion
    if StrictVersion(Qt.qVersion()) >= StrictVersion("4.5.0"):
        style = gr.prefs().get_string('qtgui', 'style', 'raster')
        Qt.QApplication.setGraphicsSystem(style)
    qapp = Qt.QApplication(sys.argv)

    tb = top_block_cls()
    tb.start()
    tb.show()

    def quitting():
        tb.stop()
        tb.wait()
    qapp.connect(qapp, Qt.SIGNAL("aboutToQuit()"), quitting)
    qapp.exec_()


if __name__ == '__main__':
    main()
