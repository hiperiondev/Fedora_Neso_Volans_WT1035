# Fedora_Neso_Volans_WT1035
*Install Fedora 27/28 on Tablet Neso Volans WT1035*

## System Hardware Summary

**[Neso Volans WT1035 10.1"] (https://www.intel.la/buy/ar/es/product/tablets/neso-volans-32gb-black-508088)**

## Hardware

```
- CPU: Intel Atom Bay Trail Z3735F
- Video: Intel HD Graphics (Atom Processor Z36xxx/Z37xxx Series Graphics & Display) 
- Screen: 10.1"
- WiFi: Realtek RTL8723BS Wireless LAN 80211n SDIO Network Adapter
- Disks: mmcblk0: mmc0:0001 NCard 28.9 GiB
- RAM: LPDDR3 1067 2GB (on-board)*
- BT: Realtek RTL8723BS_BT
```

## Project Status
```diff
+ Boot Standard Kernel
+ Detect hard drives
+ Shutdown
+ Reboot
* Hibernation
+ Sleep / Suspend
+ Battery monitor
+ Xorg
+     OpenGL (60FPS on glxgears)
+     Resize-and-Rotate(randr)
* XWayland
+ Screen backlight
* Light sensor
* Switch to External Screen (HDMI)
+ Mouse Built-in (Touchscreen)
- Bluetooth
+ Wireless/Wifi
+ Sound
+ MicroSD card reader
- Built-in camera
+ Accelerometers
* Side connector
```
```diff
Legend : 
+ xxx = OK
- xxx = Not work (maybe Unsupported)
* xxx = Unknown, Not Test
```


 1. *Install Fedora 27*
 2. *Bluetooth*
 3. *Camera*
 4. *Accelerometer*
 5. *Touchscreen*
 6. *Rotate Screen*
 7. *Side connector*

----------------------------------------

1. *Install Fedora 27*
  - Install F27 from USB
  - [...]
  - Use kernel 4.16.0-0.rc3.git2.2.fc29 from rawhide repo

2. *Bluetooth*
  - Not work. Problem with ACPI ID and rfkill-gpio. Possible solution: https://patchwork.kernel.org/patch/9831445/

3. *Camera*
  - Not work. Not idetified yet

4. *Accelerometer*
  - In kernel module bmc150_accel_i2c.
  - Ok iio-sensor-proxy

5. *Touchscreen*

   *NATIVE*
  
   *OLD (NOT RECOMENDED)*
  - Copy Firmware file Firmware/silead_ts.fw to /lib/firmware
  - Compile this trivial modified version of gslx680_acpi (from: https://github.com/onitake/gslx680-acpi)
   - Sign kernel module: https://blog.delouw.ch/2017/04/18/signing-linux-kernel-kodules-and-enforce-to-load-only-signed-modules/ 
   - Install Kernel Module:
	  insmod ./gslx680_ts_acpi.ko

    - ***Advanced: Extract Firmware***
    
      - From your original android retrieve files gslx68x_ts.ko and infosystem.txt 
      - Search in infosystem.txt something like this:
      
```
06-05 13:01:55.099   142   142 I KERNEL  : [    6.013768] ****************************************
06-05 13:01:55.099   142   142 I KERNEL  : [    6.013773] GSLX680 Enter gsl_ts_probe
06-05 13:01:55.099   142   142 I KERNEL  : [    6.013789] ==kzalloc success=
06-05 13:01:55.099   142   142 I KERNEL  : [    6.013798] === GSL I2C addr = 40 ===
06-05 13:01:55.099   142   142 I KERNEL  : [    6.013804] [GSLX680] Enter gslX680_ts_init
06-05 13:01:55.099   142   142 I KERNEL  : [    6.014538] input: GSL_TP as /devices/platform/80860F41:03/i2c-4/4-0040/input/input8
06-05 13:01:55.099   142   142 I KERNEL  : [    6.014621] [tp_gsl] IRQ_PORT =133
06-05 13:01:55.099   142   142 I KERNEL  : [    6.014650] [tp_gsl] RST_PORT =128
06-05 13:01:55.179   142   142 I KERNEL  : [    6.099334] I read reg 0xf0 is 0
06-05 13:01:55.199   142   142 I KERNEL  : [    6.117701] I write reg 0xf0 0x12
06-05 13:01:55.219   142   142 I KERNEL  : [    6.138956] I read reg 0xf0 is 0x12
06-05 13:01:55.389   142   142 I KERNEL  : [    6.308633] read 0xfc = 80 36 0 0
06-05 13:01:55.389   142   142 I KERNEL  : [    6.308688] =============gsl_load_fw start==============
06-05 13:01:55.629   142   142 I KERNEL  : [    6.551825] =============gsl_load_fw end==============
06-05 13:01:55.739   142   142 I KERNEL  : [    6.656985] =============gsl_load_cfg_adjust check start==============
06-05 13:01:56.249   142   142 I KERNEL  : [    7.169676] fuc:cfg_adjust, b8: 0 1 0 0
06-05 13:01:56.249   142   142 I KERNEL  : [    7.169729] fuc:cfg_adjust, GSL_TP_ID_TEMP: 0 
06-05 13:01:56.249   142   142 I KERNEL  : [    7.169754] temp[] 0 1 0 0
06-05 13:01:56.249   142   142 I KERNEL  : [    7.169773] fuc:cfg_adjust, cfg_adjust_used_id: 1 
06-05 13:01:56.249   142   142 I KERNEL  : [    7.169789] =============gsl_load_cfg_adjust check end==============
06-05 13:01:56.419   142   142 I KERNEL  : [    7.339029] read 0xfc = 80 36 0 0
06-05 13:01:56.419   142   142 I KERNEL  : [    7.339085] =============gsl_load_fw start==============
06-05 13:01:56.419   142   142 I KERNEL  : [    7.339109] I101_GSL3692_8001280_GG_FC_FC101S123
06-05 13:01:57.669   142   142 I KERNEL  : [    8.588004] =============gsl_load_fw end==============
06-05 13:01:57.819   142   142 I KERNEL  : [    8.739781] [GSLX680] End gsl_ts_probe
```

In this example the FW file is: I101_GSL3692_8001280_GG_FC_FC101S123
   - Extract the FW with the modified fw_extractor script (from: https://github.com/onitake/gsl-firmware)
	You can use a portion of file name to search the correct FW
	Ex:
	fw_extractor gslx68x_ts.ko GSL3692_8001280_GG_FC

    - Create fw with tools (from: https://github.com/onitake/gsl-firmware)
	fwtool -c I101_GSL3692_8001280_GG_FC_FC101S123.fw -w 1500 -h 2000 -t 10 -f track,swap,xflip silead_ts.fw

6. *Rotate Screen*
- Use RotateScreen/rotate_desktop.sh script (modified from: https://gist.github.com/mildmojo/48e9025070a2ba40795c)

7. *Side connector*
- USB OTG ?