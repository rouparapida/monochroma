//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma UseQApplication
import Quickshell
import qs.components.bar
import qs.components.osds

ShellRoot {
    Bar {}
    VolumeOSD {}
    BrightnessOSD {}
}
