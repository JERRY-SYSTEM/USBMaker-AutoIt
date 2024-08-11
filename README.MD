> [!NOTE]
>
> 原文：[无忧启动论坛](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=375076)

## **特点**：

UD三分区、UD二分区、ISO模式，自动适应。

全新写入、无损写入、便捷写入，智能切换。

无需干预一键完成。

测试环境：WINXP、WIN7、WIN8及其对应的WINPE系统。

**EFI分区**：UEFI镜像或“EFI”目录。附加文件放“EFI”目录。

**UD分区**：FBA或菜单文件。菜单文件放“MENU”目录、附加文件放“UD”目录。

**菜单文件**：由fbinst菜单（fb.cfg，可省略）和grldr菜单（grldr)组成。

## **功能**：

### **刷新磁盘文件信息**：

**程序所在目录文件结构发生改变时可通过3种方法刷新文件信息。

1.重新点选“UD三分区”下拉框（仅刷新文件信息）。

2.重新点选“选择设备”下拉框（仅刷新文件信息）。

3.点击程序窗口右上角“▼”菜单按钮。选择“刷新磁盘文件信息”（刷新磁盘文件信息）。

这3种方法刷新的效果是不同的，到底有哪些区别您自己去体验吧。

### **便捷更新UD区（清除UD区原有文件，EFI区不变）**：

依次选择“UD二分区”、“便捷写入”、“一键写入”。

### **便捷更新EFI区（清除EFI区原有文件，UD区不变）**：

点击程序窗口右上角“▼”菜单按钮。选择“更新EFI区”。

### **修复Fbinst引导记录**：

点选“选择设备”下拉框，选择一个USB设备，Fbinst引导记录将自动修复。

### **移动硬盘**：

在WINPE下写入可能出现可见区有盘符但不可见的现象。

由于在WINPE下所有隐藏分区都会分配盘符，所以EFI区一般来说是可见的。

由于移动硬盘盒线路板质量参差不齐以及计算机USB接口供电不足等因素，长时间以及连续多次进行擦除和写入操作，可能造成硬盘或数据的损坏。

## **出现问题？**：

如果重新一次写入、重新插拔USB再写入、重启计算机再写入。

首次使用本工具，建议采用“全新写入”。

制作过程中提示可见区无盘符时，需打开“磁盘管理”手动指定盘符。

制作失败一般是U盘占用或反复对U盘进行擦写操作造成的。

最有效的解决方法就是重启计算机重新制作。

## **图片预览**：

![](http://bbs.wuyou.net/forum.php?mod=attachment&aid=MjQ0NTQ2fGUzMGQ5MWIxfDE3MjMzODExNDl8MHwzNzUwNzY%3D&noupdate=yes)

![](http://bbs.wuyou.net/forum.php?mod=attachment&aid=MjQ0NTQ3fGQ1MmU5YzkzfDE3MjMzODExNDl8MHwzNzUwNzY%3D&noupdate=yes)

![](http://bbs.wuyou.net/forum.php?mod=attachment&aid=MjQ0NTQ4fDUzYzMzYmRifDE3MjMzODExNDl8MHwzNzUwNzY%3D&noupdate=yes)