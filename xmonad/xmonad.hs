-- vim: ai:et:sw=4:sts=4:
import XMonad
import qualified XMonad.StackSet as W
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Util.Run(spawnPipe, runInTerm)
import XMonad.Util.EZConfig(additionalKeysP)
import qualified XMonad.Prompt as P
import qualified XMonad.Prompt.Shell as P
import XMonad.Layout.NoBorders (smartBorders)
import System.IO

myterminal = "urxvt"

main = do xmobarp <- spawnPipe "xmobar"
          xmonad $ defaultConfig
              { modMask = mod4Mask -- "Windows" key
              , manageHook = manageDocks <+> manageHook defaultConfig <+> (isFullscreen --> doF W.focusDown <+> doFullFloat)
              , layoutHook = smartBorders $ avoidStruts $ layoutHook defaultConfig
              , logHook = dynamicLogWithPP xmobarPP
                            { ppOutput = hPutStrLn xmobarp
                            , ppTitle = xmobarColor "green" "" . shorten 80
                            }
              , terminal = myterminal
              }
              `additionalKeysP`
              [ ("M-p", P.shellPrompt P.defaultXPConfig)
              , ("M-c", termPrompt P.defaultXPConfig)
              ]

data TermPrompt = TermPrompt

instance P.XPrompt TermPrompt where
    showXPrompt TermPrompt = "Terminal: "
    completionToCommand _ = P.completionToCommand P.Shell

termPrompt :: P.XPConfig -> X ()
termPrompt c = do cmds <- io P.getCommands
                  P.mkXPrompt TermPrompt c (P.getShellCompl cmds) (runInTerm "")
