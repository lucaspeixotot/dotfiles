Vim�UnDo� �ؿ��%��,R����\�W��Pa��Qf�7�J  e   		blackbox_set_events(&events);   �                          \��k    _�                     A        ����                                                                                                                                                                                                                                                                                                                                                             \�%%     �              f   ##include <event/HardBrakeEvent.hpp>       using namespace tc;       ,#define SET_ARRAY(type, array, len, value) \   A	for(type *__ptr__ = array; __ptr__ < array + len; __ptr__++) { \   		*__ptr__ = value; \   	}       struct hard_brake_config   {   	u8_t p;   	float threshold;   	float minCost;   	float maxCost;   
	float te;   	float histeresis;   	float brakePedal;   };       4HardBrakeEvent::HardBrakeEvent(): DriverEvent(false)   {   !	m_data.threshold = -0.4; /* g */   	m_data.minCost = 0;   	m_data.maxCost = 2;   	m_param_te = 6; /* s */   	m_param_p = 3;   *	m_histeresis_higher_bound = -0.3; /* g */   0	m_brake_pedal_min_valid = 0.5; /* percentage */       	buildTemplate();   	clearBuffers();       	m_histeresisFlag = false;   }       !HardBrakeEvent::~HardBrakeEvent()   {   }       ,float HardBrakeEvent::power(float x, u8_t p)   {   	float result = x;        	for(u8_t i = 0; i < p - 1; i++)   	{   		result *= x;   	}       	return result;   }       #void HardBrakeEvent::clearBuffers()   {   	m_data.historicTotal.clear();   	m_data.historicPre.clear();   	m_data.historicPost.clear();       F	SET_ARRAY(float, m_data.historicTotalBuffer, TOTAL_HISTORIC_SIZE, 0);   F	SET_ARRAY(float, m_data.historicPreBuffer, PARTIAL_HISTORIC_SIZE, 0);   G	SET_ARRAY(float, m_data.historicPostBuffer, PARTIAL_HISTORIC_SIZE, 0);        #ifdef CONFIG_TEST_STORE_SAMPLES   	m_hardBrakeSamples.clear();   D	SET_ARRAY(float, m_hardBrakeSamplesBuffer, TOTAL_HISTORIC_SIZE, 0);   "#endif //CONFIG_TEST_STORE_SAMPLES   }       1void change_big_values(float *buffer, size_t len)   {   	float max = -INF;   	float min = INF;       *	GET_MIN_MAX(float, buffer, len, min, max)       -	for (float *p = buffer; p < buffer+len; p++)   	{   		if (*p == 1e9) {   			*p = min;   		}   	}   }       $void HardBrakeEvent::buildTemplate()   {   	float y = 0;   	float x = 0;   	float x_p = 0;   "	float step = 1.0 / m_sample_rate;   	float max = -INF;   	float min = INF;       3	for (size_t i = 0; i < TOTAL_HISTORIC_SIZE; ++i) {   		x = i * step;   		x_p = power(x, m_param_p);   		if (x < m_param_te) {   			y = 1 - x_p;   		}   		else {   			y = 1e9;   		}       #		m_data.historicTemplate.push(&y);   	}       G	change_big_values(m_data.historicTemplateBuffer, TOTAL_HISTORIC_SIZE);       E	NORMALIZE(float, m_data.historicTemplateBuffer, TOTAL_HISTORIC_SIZE,   				min, max)   }       Evoid HardBrakeEvent::setParameter(const char *parameter, char* value)   {   :	if (strcmp(parameter, HARD_BRAKE_PARAM_THRESHOLD) == 0) {   0		m_data.threshold = strtof_custom(value, NULL);   B		Math::printFloat("New acc threshold: %02f\n", m_data.threshold);   	}   >	else if (strcmp(parameter, HARD_BRAKE_PARAM_MIN_COST) == 0) {   .		m_data.minCost = strtof_custom(value, NULL);   ;		Math::printFloat("New min cost: %02f\n", m_data.minCost);   	}   >	else if (strcmp(parameter, HARD_BRAKE_PARAM_MAX_COST) == 0) {   .		m_data.maxCost = strtof_custom(value, NULL);   ;		Math::printFloat("New max cost: %02f\n", m_data.maxCost);   	}   8	else if (strcmp(parameter, HARD_BRAKE_PARAM_TE) == 0) {   *		m_param_te = strtof_custom(value, NULL);   7		Math::printFloat("New te value: %02f\n", m_param_te);   	}   7	else if (strcmp(parameter, HARD_BRAKE_PARAM_P) == 0) {   &		m_param_p = strtoul(value, NULL, 0);   3		Math::printFloat("New p value: %d\n", m_param_p);   	}   K	else if (strcmp(parameter, HARD_BRAKE_PARAM_HISTERESIS_HIGH_BOUND) == 0) {   9		m_histeresis_higher_bound = strtof_custom(value, NULL);   U		Math::printFloat("New histeresis higher bound: %02f\n", m_histeresis_higher_bound);   	}   K	else if (strcmp(parameter, HARD_BRAKE_PARAM_BRAKE_PEDAL_MIN_VALID) == 0) {   7		m_brake_pedal_min_valid = strtof_custom(value, NULL);   Q		Math::printFloat("New brake pedal min valid: %02f\n", m_brake_pedal_min_valid);   	}   	else {   T		print(NULL, (enum shell_vt100_color) 0, "[Err] Unkown parameter %s\n", parameter);   	}   }       Hbool HardBrakeEvent::checkThreshold(struct Sample samples[], size_t len)   {   9	if (samples[0].signalType != SignalType::ACCELERATION ||   A		samples[1].signalType != SignalType::BRAKE_PEDAL  || len < 2) {   		return false;   	}       	float acc = samples[0].x;       ;	if (m_histeresisFlag && acc > m_histeresis_higher_bound) {   		m_histeresisFlag = false;   	}       	if (acc <= m_data.threshold &&   7		m_brake_pedal_min_valid >= m_brake_pedal_min_valid &&   		!m_histeresisFlag) {   K		print(NULL, (enum shell_vt100_color) 0, "[HardBrake] Brake Threshold\n");   		m_histeresisFlag = false;   		return true;   	}   	else {   		return false;   	}   }       `void HardBrakeEvent::saveSamples(struct Sample samples[], size_t len, HistoricType historicType)   {   9	if (samples[0].signalType != SignalType::ACCELERATION ||   A		samples[1].signalType != SignalType::BRAKE_PEDAL  || len < 2) {   			return;   	}       	float acc = samples[0].x;       	switch (historicType) {   !	case HistoricType::HISTORIC_PRE:    		m_data.historicPre.push(&acc);   		break;   "	case HistoricType::HISTORIC_POST:   !		m_data.historicPost.push(&acc);   		break;   		default:   		break;   	}        #ifdef CONFIG_TEST_STORE_SAMPLES   	HardBrakeSample hb_sample;   G	hb_sample.set(samples[0].x, samples[0].y, samples[0].z, samples[1].x);   %	m_hardBrakeSamples.push(&hb_sample);   "#endif //CONFIG_TEST_STORE_SAMPLES   }       <bool HardBrakeEvent::isHistoricFillUp(HistoricType historic)   {   	switch (historic) {   !	case HistoricType::HISTORIC_PRE:   A		return m_data.historicPre.getAmount() == PARTIAL_HISTORIC_SIZE;   "	case HistoricType::HISTORIC_POST:   B		return m_data.historicPost.getAmount() == PARTIAL_HISTORIC_SIZE;   		default:   		return false;   	}   }       $void HardBrakeEvent::joinHistorics()   {   	float sample = 0;       -	while (m_data.historicPre.getAmount() > 0) {   "		m_data.historicPre.pop(&sample);   %		m_data.historicTotal.push(&sample);   	}       2	for (int i = 0; i < PARTIAL_HISTORIC_SIZE; ++i) {   #		m_data.historicPost.pop(&sample);   %		m_data.historicTotal.push(&sample);   	}   }        void HardBrakeEvent::normalize()   {   	float acc_min = INF;   	float acc_max = -INF;       B	NORMALIZE(float, m_data.historicTotalBuffer, TOTAL_HISTORIC_SIZE,   			  acc_min, acc_max)   }       void HardBrakeEvent::runDTW()   {   	float cost = INF;   	u8_t events = 0;    #ifdef CONFIG_TEST_STORE_SAMPLES   !	struct storable_sample s_sample;   	size_t samples_amount = 0;   	HardBrakeSample hb_sample;   "#endif //CONFIG_TEST_STORE_SAMPLES       K	cost = NaiveDTW::calcCost(m_data.historicTotalBuffer, TOTAL_HISTORIC_SIZE,   '							  m_data.historicTemplateBuffer,   							  TOTAL_HISTORIC_SIZE,   (							  DistanceAlgorithms::EUCLIDEAN);       ;	Math::printFloat("[HardBrake] DTW acc cost: %2f\n", cost);   8	if (m_data.minCost <= cost && cost <= m_data.maxCost) {   		//event occur   		blackbox_get_events(&events);   		events |= HARD_BRAKE_FLAG;   		blackbox_set_events(&events);    #ifdef CONFIG_TEST_STORE_SAMPLES   .		s_sample.sample_type = SUCCESS_EVENT_SAMPLE;   	}   	else {   +		s_sample.sample_type = FAIL_EVENT_SAMPLE;   	}       1	samples_amount = m_hardBrakeSamples.getAmount();   .	for (size_t i = 0; i < samples_amount; i++) {   %		m_hardBrakeSamples.pop(&hb_sample);       .		s_sample.remaining = samples_amount - i - 1;   (		s_sample.event_type = HARD_BRAKE_FLAG;   		s_sample.accelerometer_x = 0;   		s_sample.accelerometer_y = 0;   		s_sample.accelerometer_z = 0;   		s_sample.gyroscope_x = 0;   		s_sample.gyroscope_y = 0;   		s_sample.gyroscope_z = 0;   .		s_sample.acceleration_x = hb_sample.m_acc_x;   .		s_sample.acceleration_y = hb_sample.m_acc_y;   .		s_sample.acceleration_z = hb_sample.m_acc_z;   		s_sample.jerk_x = 0;   		s_sample.jerk_y = 0;   		s_sample.jerk_z = 0;   		s_sample.gravity_x = 0;   		s_sample.gravity_y = 0;   		s_sample.gravity_z = 0;   1		s_sample.brake_pedal = hb_sample.m_brake_pedal;       :		k_msgq_put(&storable_sample_msgq, &s_sample, K_NO_WAIT);   	}   #else   	}   "#endif //CONFIG_TEST_STORE_SAMPLES   }       void HardBrakeEvent::cleanUp()   {   	clearBuffers();   }       !void HardBrakeEvent::loadConfig()   {   	size_t ret = 0;   '	struct hard_brake_config config = {0};   	struct flash_data data = {   		.id = HARD_BRAKE_CONFIG,   		.data = &config,   )		.len = sizeof(struct hard_brake_config)   	};       )	ret = Flash::getInstance()->read(&data);    	if ((int)ret < (int)data.len) {   i		print(NULL, (enum shell_vt100_color) 0, "[WRN] Cannot load Hard Brake config. Using default config\n");   		saveConfig();   			return;   	}       %	m_data.threshold = config.threshold;   !	m_data.minCost = config.minCost;   !	m_data.maxCost = config.maxCost;   	m_param_p = config.p;   	m_param_te = config.te;   /	m_histeresis_higher_bound = config.histeresis;   -	m_brake_pedal_min_valid = config.brakePedal;   }       !void HardBrakeEvent::saveConfig()   {   	int err = 0;   $	struct hard_brake_config config = {   		.p = m_param_p,    		.threshold = m_data.threshold,   		.minCost = m_data.minCost,   		.maxCost = m_data.maxCost,   		.te = m_param_te,   *		.histeresis = m_histeresis_higher_bound,   '		.brakePedal = m_brake_pedal_min_valid   	};   	struct flash_data data = {   		.id = HARD_BRAKE_CONFIG,   		.data = &config,   )		.len = sizeof(struct hard_brake_config)   	};       *	err = Flash::getInstance()->write(&data);   	if (err < 0) {   S		print(NULL, (enum shell_vt100_color) 0, "[ERR] Cannot save Hard Brake config\n");   	}   }       !void HardBrakeEvent::showConfig()   {   E	print(NULL, (enum shell_vt100_color) 0, "***** Hard Brake *****\n");   >	Math::printFloat("threshold:  \t%.3f g\n", m_data.threshold);   :	Math::printFloat("min cost:   \t%.3f\n", m_data.minCost);   :	Math::printFloat("max cost:   \t%.3f\n", m_data.maxCost);   5	Math::printFloat("p:          \t%.3f\n", m_param_p);   8	Math::printFloat("te:         \t%.3f s\n", m_param_te);   G	Math::printFloat("histeresis: \t%.3f g\n", m_histeresis_higher_bound);   F	Math::printFloat("brake pedal:\t%.3f %%\n", m_brake_pedal_min_valid);   }5�_�                    �       ����                                                                                                                                                                                                                                                                                                                                                             \��h     �   �   �  e      		blackbox_set_events(&events);5�_�                     �       ����                                                                                                                                                                                                                                                                                                                                                             \��j    �   �   �  e      		blackbox_set_events(&vents);5��