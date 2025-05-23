/* See LICENSE file for copyright and license details. */


/* appearance */
static const unsigned int borderpx  = 3;        /* border pixel of windows */
static const unsigned int gappx     = 7;        /* gaps between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int splitstatus        = 2;        /* 1 for split status items */
static const char *splitdelim        = ";";       /* Character used for separating status */
static const char *fonts[]          = { "FiraMono Nerd Font Propo:size=9" };
static const char dmenufont[]       = "FiraMono Nerd Font Propo:size=9";
static const char col_gray1[]       = "#191724";
static const char col_gray2[]       = "#191724";
static const char col_gray3[]       = "#f6c177";
static const char col_cyan[]        = "#ebbcba"; /* for color for the select number from bar menu 1, 3, 4, 5*/
static const char col_gray4[]       = "#191724";
/*static const unsigned int baralpha = 0xdf;*/
static const unsigned int baralpha = 0x00; // fully tarnsparent
static const unsigned int borderalpha = OPAQUE;
static const char *colors[][3]      = {
    /*               fg         bg         border   */
    [SchemeNorm] = { col_gray3, col_gray1, col_gray1 },
    [SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};
static const unsigned int alphas[][3]      = {
    /*               fg      bg        border*/
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
    [SchemeSel]  = { OPAQUE, baralpha, borderalpha },
};

/* tagging */
static const char *tags[] = { "I", "II", "III", "IV", "V", "VI", "VII", "VIII" };



static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class                      instance                   title             tags mask    isfloating   monitor */
    {  NULL,                     NULL,                       NULL,             0,           0,           -1 },
    { "firefox",                 NULL,                       NULL,             1 << 1,      0,           -1 },
    { "qutebrowser",             NULL,                       NULL,             1 << 1,      0,           -1 },
    { "discord",                 NULL,                       NULL,             1 << 2,      0,           -1 },
    { "Microsoft To-Do Unofficial",NULL,                     NULL,             1 << 2,      0,           -1 },
    { "mpv"                     ,NULL,                       NULL,             1 << 2,      0,           -1 },
    { "obsidian",                NULL,                       NULL,             1 << 3,      0,           -1 },
    { "Zathura",                 NULL,                       NULL,             1 << 3,      0,           -1 },
    { "Code",                    NULL,                       NULL,             1 << 3,      0,           -1 },
    { "jetbrains-goland",        NULL,                       NULL,             1 << 3,      0,           -1 },
    { "Nemo",                    NULL,                       NULL,             1 << 4,      0,           -1 },
    { "QtSpim",                  NULL,                       NULL,             1 << 4,      0,           -1 },
    { "Zeal",                    NULL,                       NULL,             1 << 4,      0,           -1 },
    { "Postman",                 NULL,                       NULL,             1 << 5,      0,           -1 },
    { "YouTube Music",           NULL,                       NULL,             1 << 5,      0,           -1 },
    { "MongoDB Compass",         NULL,                       NULL,             1 << 5,      0,           -1 },
    { "burp-StartBurp",          NULL,                       NULL,             1 << 5,      0,           -1 },
    { "Gimp",                    NULL,                       NULL,             1 << 6,      0,           -1 },
    { "VirtualBox Manager",      NULL,                       NULL,             1 << 6,      0,           -1 },
};


/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int attachbelow = 1;    /* 1 means attach after the currently active window */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[]=",      tile },    /* first entry is default */
    { "><>",      NULL },    /* no layout function means floating behavior */
    { "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "/usr/bin/kitty", NULL };
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "st", "-t", scratchpadname, "-g", "70x24", NULL };
/*static const char *scratchpadcmd[] = { "kitty", "--title", scratchpadname, "--class", "scratchpad", "--geometry", "70x24", NULL };*/

// using sxhkd
/*static const char *rofi[]  = { "rofi", "-show", "drun", "-theme", "~/.config/rofi/rose-pine.rasi", NULL };*/

static const Key keys[] = {
    /* modifier                     key        function        argument */
    { MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
    { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
    { MODKEY,                       XK_y,  togglescratch,  {.v = scratchpadcmd } },
    { MODKEY,                       XK_b,      togglebar,      {0} },
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
    { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
    { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
    { MODKEY|ShiftMask,                       XK_Return, zoom,           {0} },
    { MODKEY,                       XK_Tab,    view,           {0} },
    { Mod4Mask,                     XK_l,      spawn,          SHCMD("slock") },
    { MODKEY,                       XK_w,      killclient,     {0} },
    { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
    { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
    { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
    { MODKEY,                       XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    TAGKEYS(                        XK_6,                      5)
    TAGKEYS(                        XK_7,                      6)
    TAGKEYS(                        XK_8,                      7)
    TAGKEYS(                        XK_9,                      8)
    { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
    { MODKEY|ControlMask|ShiftMask, XK_q,      quit,           {1} }, 
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

