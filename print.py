import os, sys
import win32print

def formatData(args):
  cnt = 1
  decimal_form_feed = 12
  decimal_line_feed = 10
  decimal_carriage_return = 13

  byteArr = bytearray()

  # Initialize printer with larger character spacing and line spacing for better readability
  # ESC @ - Initialize printer
  byteArr.extend(bytes("\u001b@", "utf-8"))
  
  # ESC 3 n - Set line spacing to n/216 inch (larger value = more space)
  # Using 30 for comfortable line spacing
  byteArr.extend(bytes("\u001b\u0033\u001e", "utf-8"))
  
  # ESC P - Select 10 CPI (characters per inch) - standard readable size
  # Use ESC M for 12 CPI (smaller) or ESC g for 15 CPI (smallest)
  byteArr.extend(bytes("\u001bP", "utf-8"))
  # print(len(args))
  while(cnt < len(args)):
    if args[cnt]=="R":
      temp = bytes (args[cnt+1], "utf-8")
      byteArr.extend(temp)
      #print(byteArr)
    elif args[cnt]=="RB":
      # ESC E - Turn on emphasized (bold) mode, ESC F - Turn off emphasized mode
      temp = bytes ("\u001bE"+args[cnt+1]+"\u001bF", "utf-8")
      byteArr.extend(temp);
      #print(byteArr)
    elif args[cnt]=="D":
      # ESC W 1 - Turn on double-width mode, ESC W 0 - Turn off double-width mode
      # SO (Shift Out) - Double-width for one line, DC4 - Cancel double-width
      temp = bytes ("\u001bW\u0001"+args[cnt+1]+"\u001bW\u0000", "utf-8")
      byteArr.extend(temp);
    elif args[cnt]=="DB":
      # Combine double-width and emphasized (bold) for maximum visibility
      temp = bytes ("\u001bW\u0001\u001bE"+args[cnt+1]+"\u001bF\u001bW\u0000", "utf-8")
      byteArr.extend(temp);
    elif args[cnt]=="newline":
      temp = bytes ("\n", "utf-8")
      byteArr.extend(temp);
      cnt = cnt+1
      continue
    elif args[cnt]=="lf":
      mCnt = 0
      #while mCnt < int(args[cnt+1]):
       # mCnt = mCnt+1
        #byteArr.extend(bytes("\n", "utf-8"))
        #byteArr.extend(bytes("\u001bJ1", "utf-8"))
    elif args[cnt]=="rf":
      mCnt = 0
      # while mCnt < int(args[cnt+1]):
      #  byteArr.extend(bytes("\u001bj2", "utf-8"))
      #  mCnt = mCnt+1
      
    cnt = cnt+2
  byteArr.extend(decimal_carriage_return.to_bytes(2, 'big'))
  byteArr.extend(decimal_form_feed .to_bytes(2, 'big'))
  #byteArr.extend(decimal_carriage_return.to_bytes(2, 'big'))
  #byteArr.extend(decimal_line_feed.to_bytes(2, 'big'))
  print(byteArr)
  mBytes = bytes(byteArr)
  return mBytes
    

printer_name = win32print.GetDefaultPrinter ()

raw_data = formatData(sys.argv)
hPrinter = win32print.OpenPrinter (printer_name)
try:
  printer_info = win32print.GetPrinter(hPrinter, 2)
  drivers = win32print.EnumPrinterDrivers(None, None, 2)
  for driver in drivers:
    if driver["Name"] == printer_info["pDriverName"]:
        printer_driver = driver
  raw_type = "XPS_PASS" if printer_driver["Version"] == 4 else "RAW"
  hJob = win32print.StartDocPrinter (hPrinter, 1, (raw_data.decode("utf-8"), None, raw_type))
  try:
    win32print.StartPagePrinter (hPrinter)
    win32print.WritePrinter (hPrinter, raw_data)
    win32print.EndPagePrinter (hPrinter)
  finally:
    win32print.EndDocPrinter (hPrinter)
finally:
  win32print.ClosePrinter (hPrinter)
