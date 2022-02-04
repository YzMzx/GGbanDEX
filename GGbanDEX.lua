gg.clearResults()
--选择所有内存范围
gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_ASHMEM | gg.REGION_BAD | gg.REGION_C_ALLOC | gg.REGION_C_BSS | gg.REGION_C_DATA | gg.REGION_C_HEAP | gg.REGION_CODE_APP | gg.REGION_CODE_SYS | gg.REGION_JAVA | gg.REGION_JAVA_HEAP | gg.REGION_OTHER | gg.REGION_PPSSPP | gg.REGION_STACK | gg.REGION_VIDEO)

--搜索文件头
gg.searchNumber("175662436", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)

--提示搜索结果 初始化结果个数变量
resultCounts = gg.getResultsCount()
gg.toast("从内存中搜索到".. resultCounts .."个dex文件")
--获取结果集合
results = gg.getResults(resultCounts)

--遍历结果集
for i=1 , resultCounts do
  --初始化起始地址 变量
  startAddr = results[i].address
  --校验035值是否正确(排除等于175662436但不是dex的数值)
  local the035Temp = {}
  the035Temp[1] = {}
  the035Temp[1].address = startAddr + 4
  the035Temp[1].flags = gg.TYPE_DWORD
  the035Temp = gg.getValues(the035Temp)
  if the035Temp[1].value == 3486512 then
    --正确的dex文件 读取fileSize(偏移量)
    local fileSizeTemp = {}
    fileSizeTemp[1] = {}
    fileSizeTemp[1].address = startAddr + 32
    fileSizeTemp[1].flags = gg.TYPE_DWORD
    fileSizeTemp = gg.getValues(fileSizeTemp)
    moveSize = fileSizeTemp[1].value
    
    --读取内存dex尾地址
    endAddr = fileSizeTemp[1].address + moveSize
    packageName = gg.getTargetPackage()
    gg.dumpMemory(startAddr,endAddr,"/sdcard/dexFile/".. packageName)
    processNow = i/resultCounts*100
    gg.toast("已完成".. processNow .."%...",true)
    --重命名文件为dex 这里我没办法了 因为要导入lfs包 你来完善吧
    --renameToDex("/sdcard/dexFile/" .. packageName,resultCounts)
  end
end

gg.clearResults()
gg.alert("脱壳完成!请查看/sdcard/dexFile/包名/文件夹!");

function renameToDex(path,counts)
  for file in lfs.dir(path) do
    if file ~= "." and file ~= ".." then
      local f = path.."/"..file
      local attr = lfs.attributes (f)
      assert (type(attr) == "table")
      if attr.mode == "file" then
		if string.find(data,".bin") ~= nil then
		  print(f)
		end
      end
    end
  end
end
