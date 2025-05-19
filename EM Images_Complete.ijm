run("Close All");
run("Clear Results");
roiManager("reset");
run("Set Measurements...", "area perimeter display redirect=None decimal=3");
run("Line Width...", "line=5");
run("Colors...", "foreground=red background=black selection=yellow");
print("\\Clear");

dir1 = getDirectory("Choose Source Directory "); 
dir2 = getDirectory("Choose Destination Directory"); 
list = getFileList(dir1);

for (i=0; i<list.length; i++){ 
      showProgress(i+1, list.length); 
     open(dir1+list[i]);

path = dir1+list[i];   
print(path);  

title = getTitle();



run("Set Scale...", "distance=0 known=0 unit=pixel");
setTool("zoom");
run("In [+]");
run("In [+]");
run("In [+]");
setTool("line");
waitForUser("Draw line to set scale");
run("Set Scale...", "distance=225 known=0.500 unit=µm");
run("Select None");
run("Save");

rename("test");
run("Original Scale");
setTool("oval");
waitForUser("Draw region around mitochondria and add it to ROI manager");
roiManager("Add");
roiManager("Select", 0);
roiManager("Rename", "Area");
selectWindow("test");
rename("Area");
run("Measure");
rename("test");
run("Select None");
run("Duplicate...", " ");
run("RGB Color");
roiManager("Select", 0);
setForegroundColor(255, 0, 0);
run("Draw", "slice");
saveAs("Tiff", dir2 +" "+title+"_Image.tif");
run("Close");
selectWindow("test");
rename("MitoLength");
setTool("line");
run("Select None");
waitForUser("Draw a line at thickest section of mitochondria and press CTRL-T then CTRL-M");
waitForUser("Draw a line at the center of Yeast cells and press CTRL-T then CTRL-M");
roiManager("Save",  dir2 +" "+title+"_RoiSet.zip");

selectWindow("Results");
saveAs("Results", dir2 +" "+title+"_Result.txt");


rename("test");
roiManager("Select", 0);
roiManager("Show All with labels");
Dialog.create("COUNT MITOCHONDRIA RINgs");
Dialog.addNumber("Count the mitochondria:", 10);
Dialog.addNumber("Count the Rings:", 10);
Dialog.addNumber("Count conected junction:", 10);
Dialog.addNumber("Count number of constrictions:", 10);
Dialog.addNumber("count Isolated motochondria:", 10);
Dialog.show();
m = Dialog.getNumber();
q = Dialog.getNumber();
n = Dialog.getNumber();
o = Dialog.getNumber();
p = Dialog.getNumber();

print(title);
print(m);
print(q);
print(n);
print(o);
print(p);
waitForUser("Copy data on excel");
roiManager("reset");
run("Clear Results");
close();
}
 selectWindow("Log");
saveAs("Text", dir2 + "Log.txt");
waitForUser("Save the LOG window, if it is not saved");