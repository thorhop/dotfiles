-- vim: ai:et:sw=4:sts=4:
import XMonad
import qualified XMonad.StackSet as W
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe, runInTerm)
import XMonad.Util.EZConfig(additionalKeysP)
import qualified XMonad.Prompt as P
import qualified XMonad.Prompt.Shell as P
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Tabbed
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Simplest
import XMonad.Layout.BoringWindows
import XMonad.Actions.Submap
import XMonad.Hooks.SetWMName (setWMName)
import System.IO

myterminal = "urxvt"

main = do xmobarp <- spawnPipe "xmobar"
          xmonad (myConfig { logHook = dynamicLogWithPP xmobarPP
                                { ppOutput = hPutStrLn xmobarp
                                , ppTitle = xmobarColor "green" "" . shorten 80
                                }
                           })


myConfig = defaultConfig
              { modMask = mod4Mask -- "Windows" key
              , manageHook = myManageHook
              , layoutHook = myLayout
              , terminal = myterminal
              , startupHook = setWMName "LG3D" -- minecraft
              }
              `additionalKeysP`
              [ ("M-p", P.shellPrompt P.defaultXPConfig)
              , ("M-S-p", termPrompt P.defaultXPConfig)
              , ("M-<L>", sendMessage $ Go L)
              , ("M-<R>", sendMessage $ Go R)
              , ("M-<U>", sendMessage $ Go U)
              , ("M-<D>", sendMessage $ Go D)
              , ("M-C-<L>", sendMessage $ Swap L)
              , ("M-C-<R>", sendMessage $ Swap R)
              , ("M-C-<U>", sendMessage $ Swap U)
              , ("M-C-<D>", sendMessage $ Swap D)
              , ("M-C-h", sendMessage $ pullGroup L)
              , ("M-C-l", sendMessage $ pullGroup R)
              , ("M-C-k", sendMessage $ pullGroup U)
              , ("M-C-j", sendMessage $ pullGroup D)
              , ("M-C-m", withFocused $ sendMessage . MergeAll)
              , ("M-C-u", withFocused $ sendMessage . UnMerge)
              , ("M-C-.", onGroup W.focusUp')
              , ("M-C-,", onGroup W.focusDown')
              , ("M-C-<Space>", toSubl NextLayout)
              , ("M-s", submap $ defaultSublMap myConfig)
              , ("M-j", focusDown)
              , ("M-k", focusUp)
              , ("M-m", focusMaster)
              , ("M-/", spawn "amixer set Master toggle")
              ]


myLayout = smartBorders
         $ avoidStruts
         $ configurableNavigation (navigateColor "#ffff00")
         $ addTabs shrinkText defaultTheme
         $ boringAuto
         $ subLayout [] (Simplest ||| Tall 1 0.2 0.5)
         $ layoutHook defaultConfig


wmWindowRole = stringProperty "WM_WINDOW_ROLE"

myManageHook = composeAll
    [ manageDocks
    , composeOne
        [
          firefoxHook
        , wmWindowRole =? "GtkFileChooserDialog" -?> doCenterFloat
        , isFullscreen -?> (doF W.focusDown <+> doFullFloat)
        ]
    , manageHook defaultConfig
    ]
    where firefoxHook = className =? "Firefox" <&&> wmWindowRole /=? "browser" -?> doCenterFloat


data TermPrompt = TermPrompt

instance P.XPrompt TermPrompt where
    showXPrompt TermPrompt = "Terminal: "
    completionToCommand _ = P.completionToCommand P.Shell

termPrompt :: P.XPConfig -> X ()
termPrompt c = do cmds <- io P.getCommands
                  P.mkXPrompt TermPrompt c (P.getShellCompl cmds) (runInTerm "")
