require 'ffi.gctypes'
local ffi = require 'ffi'


ffi.cdef[[

/* led bit masks */
enum { WIIMOTE_LED_NONE = 0x00 };
enum { WIIMOTE_LED_1 = 0x10 };
enum { WIIMOTE_LED_2 = 0x20 };
enum { WIIMOTE_LED_3 = 0x40 };
enum { WIIMOTE_LED_4 = 0x80 };

/* button codes */
enum { WIIMOTE_BUTTON_TWO = 0x0001 };
enum { WIIMOTE_BUTTON_ONE = 0x0002 };
enum { WIIMOTE_BUTTON_B = 0x0004 };
enum { WIIMOTE_BUTTON_A = 0x0008 };
enum { WIIMOTE_BUTTON_MINUS = 0x0010 };
enum { WIIMOTE_BUTTON_ZACCEL_BIT6 = 0x0020 };
enum { WIIMOTE_BUTTON_ZACCEL_BIT7 = 0x0040 };
enum { WIIMOTE_BUTTON_HOME = 0x0080 };
enum { WIIMOTE_BUTTON_LEFT = 0x0100 };
enum { WIIMOTE_BUTTON_RIGHT = 0x0200 };
enum { WIIMOTE_BUTTON_DOWN = 0x0400 };
enum { WIIMOTE_BUTTON_UP = 0x0800 };
enum { WIIMOTE_BUTTON_PLUS = 0x1000 };
enum { WIIMOTE_BUTTON_ZACCEL_BIT4 = 0x2000 };
enum { WIIMOTE_BUTTON_ZACCEL_BIT5 = 0x4000 };
enum { WIIMOTE_BUTTON_UNKNOWN = 0x8000 };
enum { WIIMOTE_BUTTON_ALL = 0x1F9F };

/* nunchul button codes */
enum { NUNCHUK_BUTTON_Z = 0x01 };
enum { NUNCHUK_BUTTON_C = 0x02 };
enum { NUNCHUK_BUTTON_ALL = 0x03 };

/* classic controller button codes */
enum { CLASSIC_CTRL_BUTTON_UP = 0x0001 };
enum { CLASSIC_CTRL_BUTTON_LEFT = 0x0002 };
enum { CLASSIC_CTRL_BUTTON_ZR = 0x0004 };
enum { CLASSIC_CTRL_BUTTON_X = 0x0008 };
enum { CLASSIC_CTRL_BUTTON_A = 0x0010 };
enum { CLASSIC_CTRL_BUTTON_Y = 0x0020 };
enum { CLASSIC_CTRL_BUTTON_B = 0x0040 };
enum { CLASSIC_CTRL_BUTTON_ZL = 0x0080 };
enum { CLASSIC_CTRL_BUTTON_FULL_R = 0x0200 };
enum { CLASSIC_CTRL_BUTTON_PLUS = 0x0400 };
enum { CLASSIC_CTRL_BUTTON_HOME = 0x0800 };
enum { CLASSIC_CTRL_BUTTON_MINUS = 0x1000 };
enum { CLASSIC_CTRL_BUTTON_FULL_L = 0x2000 };
enum { CLASSIC_CTRL_BUTTON_DOWN = 0x4000 };
enum { CLASSIC_CTRL_BUTTON_RIGHT = 0x8000 };
enum { CLASSIC_CTRL_BUTTON_ALL = 0xFEFF };

/* guitar hero 3 button codes */
enum { GUITAR_HERO_3_BUTTON_STRUM_UP = 0x0001 };
enum { GUITAR_HERO_3_BUTTON_YELLOW = 0x0008 };
enum { GUITAR_HERO_3_BUTTON_GREEN = 0x0010 };
enum { GUITAR_HERO_3_BUTTON_BLUE = 0x0020 };
enum { GUITAR_HERO_3_BUTTON_RED = 0x0040 };
enum { GUITAR_HERO_3_BUTTON_ORANGE = 0x0080 };
enum { GUITAR_HERO_3_BUTTON_PLUS = 0x0400 };
enum { GUITAR_HERO_3_BUTTON_MINUS = 0x1000 };
enum { GUITAR_HERO_3_BUTTON_STRUM_DOWN = 0x4000 };
enum { GUITAR_HERO_3_BUTTON_ALL = 0xFEFF };

/* guitar hero world tour touch bar codes */
enum { GUITAR_HERO_3_TOUCH_AVAILABLE = 0x1000 };
enum { GUITAR_HERO_3_TOUCH_GREEN = 0x1001 };
enum { GUITAR_HERO_3_TOUCH_RED = 0x1002 };
enum { GUITAR_HERO_3_TOUCH_YELLOW = 0x1004 };
enum { GUITAR_HERO_3_TOUCH_BLUE = 0x1008 };
enum { GUITAR_HERO_3_TOUCH_ORANGE = 0x1010 };

/* wiimote option flags */
enum { WIIUSE_SMOOTHING = 0x01 };
enum { WIIUSE_CONTINUOUS = 0x02 };
enum { WIIUSE_ACCEL_THRESH = 0x04 };
enum { WIIUSE_IR_THRESH = 0x08 };
enum { WIIUSE_JS_THRESH = 0x10 };
enum { WIIUSE_INIT_FLAGS = WIIUSE_SMOOTHING };

enum { WIIUSE_ORIENT_PRECISION = 100 };	//100.0f

/* expansion codes */
enum { EXP_NONE = 0 };
enum { EXP_NUNCHUK = 1 };
enum { EXP_CLASSIC = 2 };
enum { EXP_GUITAR_HERO_3 = 3 };
enum { EXP_WII_BOARD = 4 };
enum { EXP_MOTION_PLUS = 5 };

/* IR correction types */
typedef enum ir_position_t {
	WIIUSE_IR_ABOVE,
	WIIUSE_IR_BELOW
} ir_position_t;

/*
 *	Largest known payload is 21 bytes.
 *	Add 2 for the prefix and round up to a power of 2.
 */
enum { MAX_PAYLOAD = 32 };

typedef unsigned char ubyte;
typedef char sbyte;
typedef unsigned short uword;
typedef short sword;
typedef unsigned int uint;
typedef char sint;


struct wiimote_t;
struct vec3b_t;
struct orient_t;
struct gforce_t;

typedef void (*wii_event_cb)(struct wiimote_t*, int event);

/**
 *      @brief Callback that handles a read event.
 *
 *      @param wm               Pointer to a wiimote_t structure.
 *      @param data             Pointer to the filled data block.
 *      @param len              Length in bytes of the data block.
 *
 *      @see wiiuse_init()
 *
 *      A registered function of this type is called automatically by the wiiuse
 *      library when the wiimote has returned the full data requested by a previous
 *      call to wiiuse_read_data().
 */
typedef void (*wiiuse_data_cb)(struct wiimote_t* wm, ubyte* data, unsigned short len);

typedef enum data_req_s
{
	REQ_READY = 0,
	REQ_SENT,
	REQ_DONE
} data_req_s;

/**
 *	@struct data_req_t
 *	@brief Data read request structure.
 */
struct data_req_t {
	lwp_node node;
	ubyte data[48];					/**< buffer where read data is written						*/
	unsigned int len;
	data_req_s state;			/**< set to 1 if not using callback and needs to be cleaned up	*/
	wiiuse_data_cb cb;			/**< read data callback											*/
	struct data_req_t *next;
};

typedef void (*cmd_blk_cb)(struct wiimote_t *wm,ubyte *data,uword len);

typedef enum cmd_blk_s
{
	CMD_READY = 0,
	CMD_SENT,
	CMD_DONE
} cmd_blk_s;

struct cmd_blk_t 
{
	lwp_node node;

	ubyte data[48];
	uint len;

	cmd_blk_s state;
	cmd_blk_cb cb;

	struct cmd_blk_t *next;
};


/**
 *	@struct vec2b_t
 *	@brief Unsigned x,y byte vector.
 */
typedef struct vec2b_t {
	ubyte x, y;
} vec2b_t;


/**
*	@struct vec3b_t
*	@brief Unsigned x,y,z byte vector.
*/
typedef struct vec3b_t {
	ubyte x, y, z;
} vec3b_t;

/**
*	@struct vec3b_t
*	@brief Unsigned x,y,z byte vector.
*/
typedef struct vec3w_t {
	uword x, y, z;
} vec3w_t;


/**
 *	@struct vec3f_t
 *	@brief Signed x,y,z float struct.
 */
typedef struct vec3f_t {
	float x, y, z;
} vec3f_t;


/**
 *	@struct orient_t
 *	@brief Orientation struct.
 *
 *	Yaw, pitch, and roll range from -180 to 180 degrees.
 */
typedef struct orient_t {
	float roll;						/**< roll, this may be smoothed if enabled	*/
	float pitch;					/**< pitch, this may be smoothed if enabled	*/
	float yaw;

	float a_roll;					/**< absolute roll, unsmoothed				*/
	float a_pitch;					/**< absolute pitch, unsmoothed				*/
} orient_t;


/**
 *	@struct gforce_t
 *	@brief Gravity force struct.
 */
typedef struct gforce_t {
	float x, y, z;
} gforce_t;


/**
 *	@struct accel_t
 *	@brief Accelerometer struct. For any device with an accelerometer.
 */
typedef struct accel_t {
	struct vec3w_t cal_zero;		/**< zero calibration					*/
	struct vec3w_t cal_g;			/**< 1g difference around 0cal			*/

	float st_roll;					/**< last smoothed roll value			*/
	float st_pitch;					/**< last smoothed roll pitch			*/
	float st_alpha;					/**< alpha value for smoothing [0-1]	*/
} accel_t;


/**
 *	@struct ir_dot_t
 *	@brief A single IR source.
 */
typedef struct ir_dot_t {
	ubyte visible;					/**< if the IR source is visible		*/

	short rx;						/**< raw X coordinate (0-1023)			*/
	short ry;						/**< raw Y coordinate (0-767)			*/

	ubyte size;						/**< size of the IR dot (0-15)			*/
} ir_dot_t;


typedef struct fdot_t {
	float x,y;
} fdot_t;

typedef struct sb_t {
	fdot_t dots[2];
	fdot_t acc_dots[2];
	fdot_t rot_dots[2];
	float angle;
	float off_angle;
	float score;
} sb_t;

/**
 *	@enum aspect_t
 *	@brief Screen aspect ratio.
 */
typedef enum aspect_t {
	WIIUSE_ASPECT_4_3,
	WIIUSE_ASPECT_16_9
} aspect_t;


/**
 *	@struct ir_t
 *	@brief IR struct. Hold all data related to the IR tracking.
 */
typedef struct ir_t {
	struct ir_dot_t dot[4];			/**< IR dots							*/
	ubyte num_dots;					/**< number of dots at this time		*/

	int state;						/**< keeps track of the IR state		*/

	int raw_valid;					/**< is the raw position valid? 		*/
	sb_t sensorbar;					/**< sensor bar, detected or guessed	*/
	float ax;						/**< raw X coordinate					*/
	float ay;						/**< raw Y coordinate					*/
	float distance;					/**< pixel width of the sensor bar		*/
	float z;						/**< calculated distance in meters		*/
	float angle;					/**< angle of the wiimote to the sensor bar*/

	int smooth_valid;				/**< is the smoothed position valid? 	*/
	float sx;						/**< smoothed X coordinate				*/
	float sy;						/**< smoothed Y coordinate				*/
	float error_cnt;				/**< error count, for smoothing algorithm*/
	float glitch_cnt;				/**< glitch count, same					*/

	int valid;						/**< is the bounded position valid? 	*/
	float x;						/**< bounded X coordinate				*/
	float y;						/**< bounded Y coordinate				*/
	enum aspect_t aspect;			/**< aspect ratio of the screen			*/
	enum ir_position_t pos;			/**< IR sensor bar position				*/
	unsigned int vres[2];			/**< IR virtual screen resolution		*/
	int offset[2];					/**< IR XY correction offset			*/

} ir_t;


/**
 *	@struct joystick_t
 *	@brief Joystick calibration structure.
 *
 *	The angle \a ang is relative to the positive y-axis into quadrant I
 *	and ranges from 0 to 360 degrees.  So if the joystick is held straight
 *	upwards then angle is 0 degrees.  If it is held to the right it is 90,
 *	down is 180, and left is 270.
 *
 *	The magnitude \a mag is the distance from the center to where the
 *	joystick is being held.  The magnitude ranges from 0 to 1.
 *	If the joystick is only slightly tilted from the center the magnitude
 *	will be low, but if it is closer to the outter edge the value will
 *	be higher.
 */
typedef struct joystick_t {
	struct vec2b_t max;				/**< maximum joystick values	*/
	struct vec2b_t min;				/**< minimum joystick values	*/
	struct vec2b_t center;			/**< center joystick values		*/
	struct vec2b_t pos;				/**< raw position values        */

	float ang;						/**< angle the joystick is being held		*/
	float mag;						/**< magnitude of the joystick (range 0-1)	*/
} joystick_t;


/**
 *	@struct nunchuk_t
 *	@brief Nunchuk expansion device.
 */
typedef struct nunchuk_t {
	struct accel_t accel_calib;		/**< nunchuk accelerometer calibration		*/
	struct joystick_t js;			/**< joystick calibration					*/

	int* flags;						/**< options flag (points to wiimote_t.flags) */

	ubyte btns;						/**< what buttons have just been pressed	*/
	ubyte btns_last;				/**< what buttons have just been pressed	*/
	ubyte btns_held;				/**< what buttons are being held down		*/
	ubyte btns_released;			/**< what buttons were just released this	*/

	struct vec3w_t accel;			/**< current raw acceleration data			*/
	struct orient_t orient;			/**< current orientation on each axis		*/
	struct gforce_t gforce;			/**< current gravity forces on each axis	*/
} nunchuk_t;


/**
 *	@struct classic_ctrl_t
 *	@brief Classic controller expansion device.
 */
typedef struct classic_ctrl_t {
	short btns;						/**< what buttons have just been pressed	*/
	short btns_last;				/**< what buttons have just been pressed	*/
	short btns_held;				/**< what buttons are being held down		*/
	short btns_released;			/**< what buttons were just released this	*/

	ubyte rs_raw;
	ubyte ls_raw;

	float r_shoulder;				/**< right shoulder button (range 0-1)		*/
	float l_shoulder;				/**< left shoulder button (range 0-1)		*/

	struct joystick_t ljs;			/**< left joystick calibration				*/
	struct joystick_t rjs;			/**< right joystick calibration				*/
} classic_ctrl_t;


/**
 *	@struct guitar_hero_3_t
 *	@brief Guitar Hero 3 expansion device.
 */
typedef struct guitar_hero_3_t {
	short btns;						/**< what buttons have just been pressed	*/
	short btns_last;				/**< what buttons have just been pressed	*/
	short btns_held;				/**< what buttons are being held down		*/
	short btns_released;			/**< what buttons were just released this	*/

	ubyte wb_raw;
	float whammy_bar;				/**< whammy bar (range 0-1)					*/

	ubyte tb_raw;
	int touch_bar;					/**< touch bar								*/

	struct joystick_t js;			/**< joystick calibration					*/
} guitar_hero_3_t;

/**
  * @struct wii_board_t
  * @brief Wii Balance Board expansion device.
  */
typedef struct wii_board_t {
	float tl;  /* Interpolated */
	float tr;
	float bl;
	float br;  /* End interp */
	short rtl; /* RAW */
	short rtr;
	short rbl;
	short rbr; /* /RAW */
	short ctl[3]; /* Calibration */
	short ctr[3];
	short cbl[3];
	short cbr[3]; /* /Calibration */
	float x;
	float y;
} wii_board_t;

typedef struct motion_plus_t
{
	short rx, ry, rz;
	ubyte status;
	ubyte ext;
} motion_plus_t;

/**
 *	@struct expansion_t
 *	@brief Generic expansion device plugged into wiimote.
 */
typedef struct expansion_t {
	int type;						/**< type of expansion attached				*/

	union {
		struct nunchuk_t nunchuk;
		struct classic_ctrl_t classic;
		struct guitar_hero_3_t gh3;
 		struct wii_board_t wb;
		struct motion_plus_t mp;
	};
} expansion_t;


/**
 *	@enum win32_bt_stack_t
 *	@brief	Available bluetooth stacks for Windows.
 */
typedef enum win_bt_stack_t {
	WIIUSE_STACK_UNKNOWN,
	WIIUSE_STACK_MS,
	WIIUSE_STACK_BLUESOLEIL
} win_bt_stack_t;


/**
 *	@struct wiimote_state_t
 *	@brief Significant data from the previous event.
 */
typedef struct wiimote_state_t {
	unsigned short btns;

	struct ir_t ir;
	struct vec3w_t accel;
	struct expansion_t exp;
} wiimote_state_t;


/**
 *	@enum WIIUSE_EVENT_TYPE
 *	@brief Events that wiiuse can generate from a poll.
 */
typedef enum WIIUSE_EVENT_TYPE {
	WIIUSE_NONE = 0,
	WIIUSE_EVENT,
	WIIUSE_STATUS,
	WIIUSE_CONNECT,
	WIIUSE_DISCONNECT,
	WIIUSE_UNEXPECTED_DISCONNECT,
	WIIUSE_READ_DATA,
	WIIUSE_WRITE_DATA,
	WIIUSE_NUNCHUK_INSERTED,
	WIIUSE_NUNCHUK_REMOVED,
	WIIUSE_CLASSIC_CTRL_INSERTED,
	WIIUSE_CLASSIC_CTRL_REMOVED,
	WIIUSE_GUITAR_HERO_3_CTRL_INSERTED,
 	WIIUSE_GUITAR_HERO_3_CTRL_REMOVED,
 	WIIUSE_WII_BOARD_INSERTED,
 	WIIUSE_WII_BOARD_REMOVED,
 	WIIUSE_MOTION_PLUS_ACTIVATED,
 	WIIUSE_MOTION_PLUS_REMOVED
} WIIUSE_EVENT_TYPE;

/**
 *	@struct wiimote_t
 *	@brief Wiimote structure.
 */
typedef struct wiimote_t {
	int unid;						/**< user specified id						*/

	lwp_queue cmdq;
	struct bd_addr bdaddr;		/**< bt address								*/
	char bdaddr_str[18];			/**< readable bt address					*/
	struct bte_pcb *sock;	/**< output socket							*/
	wii_event_cb event_cb;		/**< event callback							*/

	int state;						/**< various state flags					*/
	ubyte leds;						/**< currently lit leds						*/
	ubyte battery_level;				/**< battery level							*/

	int flags;						/**< options flag							*/

	ubyte handshake_state;			/**< the state of the connection handshake	*/
	ubyte expansion_state;			/**< the state of the expansion handshake	*/

	struct data_req_t* data_req;		/**< list of data read requests				*/
	
	struct cmd_blk_t *cmd_head;
	struct cmd_blk_t *cmd_tail;

	struct accel_t accel_calib;		/**< wiimote accelerometer calibration		*/
	struct expansion_t exp;			/**< wiimote expansion device				*/

	struct vec3w_t accel;			/**< current raw acceleration data			*/
	struct orient_t orient;			/**< current orientation on each axis		*/
	struct gforce_t gforce;			/**< current gravity forces on each axis	*/

	struct ir_t ir;					/**< IR data								*/

	unsigned short btns;				/**< what buttons are down					*/
	unsigned short btns_last;		/**< what buttons were down before			*/
	unsigned short btns_held;		/**< what buttons are and were held down	*/
	unsigned short btns_released;	/**< what buttons were just released		*/

	struct wiimote_state_t lstate;	/**< last saved state						*/

	WIIUSE_EVENT_TYPE event;			/**< type of event that occured				*/
	ubyte event_buf[MAX_PAYLOAD];		/**< event buffer							*/

	ubyte motion_plus_id[6];
} wiimote;

/**
 * @struct wiimote_listen_t
 * @brief Wiimote listen structure.
 */
typedef struct wiimote_listen_t {
	struct bd_addr bdaddr;
	struct bte_pcb *sock;
	struct wiimote_t *(*assign_cb)(struct bd_addr *bdaddr);
	struct wiimote_t *wm;
} wiimote_listen;

/* wiiuse.c */
extern const char* wiiuse_version();

extern int wiiuse_register(struct wiimote_listen_t *wml, struct bd_addr *bdaddr, struct wiimote_t *(*assign_cb)(struct bd_addr *bdaddr));
extern struct wiimote_t** wiiuse_init(int wiimotes, wii_event_cb event_cb);
extern void wiiuse_sensorbar_enable(int enable);

extern void wiiuse_disconnected(struct wiimote_t* wm);
extern void wiiuse_cleanup(struct wiimote_t** wm, int wiimotes);
extern void wiiuse_rumble(struct wiimote_t* wm, int status);
extern void wiiuse_toggle_rumble(struct wiimote_t* wm);
extern void wiiuse_set_leds(struct wiimote_t* wm, int leds,cmd_blk_cb cb);
extern void wiiuse_motion_sensing(struct wiimote_t* wm, int status);
extern int wiiuse_read_data(struct wiimote_t* wm, ubyte* buffer, unsigned int offset, unsigned short len, cmd_blk_cb cb);
extern int wiiuse_write_data(struct wiimote_t *wm,unsigned int addr,ubyte *data,ubyte len,cmd_blk_cb cb);
extern void wiiuse_status(struct wiimote_t *wm,cmd_blk_cb cb);
extern struct wiimote_t* wiiuse_get_by_id(struct wiimote_t** wm, int wiimotes, int unid);
extern int wiiuse_set_flags(struct wiimote_t* wm, int enable, int disable);
extern float wiiuse_set_smooth_alpha(struct wiimote_t* wm, float alpha);
extern void wiiuse_set_bluetooth_stack(struct wiimote_t** wm, int wiimotes, enum win_bt_stack_t type);
extern void wiiuse_resync(struct wiimote_t* wm);
extern void wiiuse_set_timeout(struct wiimote_t** wm, int wiimotes, ubyte normal_timeout, ubyte exp_timeout);
extern int wiiuse_write_streamdata(struct wiimote_t *wm,ubyte *data,ubyte len,cmd_blk_cb cb);

/* connect.c */
extern int wiiuse_find(struct wiimote_t** wm, int max_wiimotes, int timeout);
extern int wiiuse_connect(struct wiimote_t** wm, int wiimotes);
extern void wiiuse_disconnect(struct wiimote_t* wm);

/* events.c */
extern int wiiuse_poll(struct wiimote_t** wm, int wiimotes);

/* ir.c */
extern void wiiuse_set_ir_mode(struct wiimote_t *wm);
extern void wiiuse_set_ir(struct wiimote_t* wm, int status);
extern void wiiuse_set_ir_vres(struct wiimote_t* wm, unsigned int x, unsigned int y);
extern void wiiuse_set_ir_position(struct wiimote_t* wm, enum ir_position_t pos);
extern void wiiuse_set_aspect_ratio(struct wiimote_t* wm, enum aspect_t aspect);
extern void wiiuse_set_ir_sensitivity(struct wiimote_t* wm, int level);

/* motion_plus.c */
extern void wiiuse_set_motion_plus(struct wiimote_t *wm, int status);

/* speaker.c */
extern void wiiuse_set_speaker(struct wiimote_t *wm, int status);
]]

return ffi.C