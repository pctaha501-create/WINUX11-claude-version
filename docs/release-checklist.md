# Release checklist

- [ ] Core CMake configure succeeds.
- [ ] Release build succeeds.
- [ ] Automated tests succeed.
- [ ] Installation validation succeeds.
- [ ] WINUX11 session scripts pass shell validation.
- [ ] Compositor starts and creates its Wayland socket.
- [ ] Shell connects to compositor IPC.
- [ ] A Wayland client creates, receives focus, resizes and closes a window.
- [ ] Workspaces and snap/maximize operations are smoke-tested.
- [ ] Filesystem operations are tested on a real Linux filesystem.
- [ ] Network, audio, storage, process and security backends report unavailable capabilities honestly.
- [ ] Wine/Proton detection is tested with and without Wine.
- [ ] Optional WebEngine build is verified when available.
- [ ] ISO generation is enabled only after these checks pass.
