-- import XMonad
-- import XMonad.Config.Gnome
-- import XMonad.Layout.NoBorders
-- main = xmonad
--     gnomeConfig {
--             terminal = "urxvtcd"
--           , layoutHook  = smartBorders (layoutHook gnomeConfig)
--     }
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Gnome
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Actions.UpdatePointer
import XMonad.Actions.CopyWindow
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ICCCMFocus
import XMonad.Layout.NoBorders
import XMonad.Layout.ShowWName
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.Spiral
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import System.IO
import XMonad.Layout.IM
import Data.Ratio ((%))
import XMonad.Layout.Grid
import XMonad.Layout.PerWorkspace
import XMonad.Actions.Warp
 
main = do
  xmonad $ gnomeConfig
             { manageHook = myManageHook <+> manageHook gnomeConfig
             , layoutHook = myLayoutHook
             , workspaces = myWorkspaces
             , modMask    = mod4Mask -- rebind mod to the windows key
	     , terminal   = "urxvtcd"
	     , logHook    = takeTopFocus >> setWMName "LG3D"
             } `additionalKeysP` keys 
      where
        myManageHook :: ManageHook
        myManageHook = composeAll
                       [ manageDocks -- get class name with xprop | grep WM_CLASS
                       , className =? "Firefox"       --> doShift "web"
                       , className =? "google-chrome" --> doShift "web"
                       , className =? "Google-chrome" --> doShift "web"
                       , className =? "gnome-www-browser" --> doShift "web"
                       , className =? "Songbird"      --> doShift "6"
                       , className =? "Mail"          --> doShift "mail"
                       , className =? "Shredder"      --> doShift "mail"
                       , className =? "Thunderbird"   --> doShift "mail"
                       , className =? "Eclipse"       --> doShift "eclipse"
                       , className =? "java-lang-Thread"          --> doShift "eclipse"
                       , className =? "Skype"         --> doShift "skype"
                       , className =? "Mumbles"       --> doFloat
                       , className =? "Shutter"       --> doFloat
                       , className =? "stalonetray"   --> doIgnore
                       , title     =? "Do"            --> doIgnore
                       , isFullscreen --> doFullFloat
                       ]
        myLayoutHook = onWorkspaces ["skype"] imLayout $ genericLayoutHook
        genericLayoutHook = avoidStruts $ 
                       showWName $
                       Mirror tall ||| tall ||| simpleTabbed 
                       ||| Accordion ||| spiral (0.61)
        imLayout =  avoidStruts $ showWName $ withIM ratioIM roster chatLayout where
            chatLayout = Grid
            ratioIM    = 1%7
            roster     = (ClassName "Skype") `And` (Not (Title "Options")) `And` (Not (Role "Chats")) `And` (Not (Role "CallWindowForm"))
        tall = Tall nmaster delta ratio
        nmaster = 1
        delta = 3/100
        ratio = 1/2
        keys = [ ("M-S-z", spawn "gnome-screensaver-command --lock")
               , ("M-p", spawn "gnome-do")
	       , ("M-S-p", spawn "gmrun")
               , ("M-q", spawn "gnome-session-save --gui --logout-dialog")
               , ("M-S-q", spawn "gnome-session-save --gui --logout-dialog")
               , ("M-<Left>", prevScreen)
               , ("M-<Right>", nextScreen)
               , ("M-S-<Left>", shiftPrevScreen)
               , ("M-S-<Right>", shiftNextScreen)
               , ("M-<Down>", warpToScreen 1 (1%2) (1%2))
               , ("M-<Up>", warpToScreen 0 (1%2) (1%2))
               , ("M-<KP_1>", windows $ W.greedyView "shell")
               ] ++ [ (shift++key, windows $ f i) | (f,shift) <- [ (W.greedyView, "M-") , (W.shift, "M-S-") ], (i,key) <- zip myWorkspaces numPadKeys ]

        -- Cannot use the number versions, as XMonad ignores the numlock state.
        numPadKeys = [ "<KP_End>",  "<KP_Down>",  "<KP_Page_Down>" -- 1, 2, 3
                     , "<KP_Left>", "<KP_Begin>", "<KP_Right>"     -- 4, 5, 6
                     , "<KP_Home>", "<KP_Up>",    "<KP_Page_Up>"   -- 7, 8, 9
                     , "<KP_Insert>"] -- 0 

        myWorkspaces = ["shell","web","emacs","eclipse"] ++ map show [5..7] ++ ["skype","mail"]
