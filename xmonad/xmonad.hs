-- vim: ai:et:sw=4:sts=4:
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do xmobarp <- spawnPipe "xmobar"
          xmonad $ defaultConfig
              { modMask = mod4Mask -- "Windows" key
              , manageHook = manageDocks <+> manageHook defaultConfig
              , layoutHook = avoidStruts $ layoutHook defaultConfig
              , logHook = dynamicLogWithPP xmobarPP
                            { ppOutput = hPutStrLn xmobarp
                            , ppTitle = xmobarColor "green" "" . shorten 80
                            }
              }
