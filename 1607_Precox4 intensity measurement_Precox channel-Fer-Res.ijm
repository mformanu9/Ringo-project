run("Close All");
roiManager("reset");
run("Clear Results");
run("Channels Tool...");
run("Brightness/Contrast...");
run("Threshold...");
run("Set Measurements...", "area mean standard min perimeter integrated display redirect=None decimal=3");
run("Options...", "iterations=1 count=1 black do=Nothing");

dir1 = getDirectory("Choose Source Directory "); 
dir2 = getDirectory("Choose Destination Directory"); 
list = getFileList(dir1);

for (i=0; i<list.length; i++){ 
      showProgress(i+1, list.length); 
     open(dir1+list[i]);

path = dir1+list[i];     
print(path);

roiManager("reset");
title=getTitle();

/*
//projection
rename("test");
run("Z Project...", "projection=[Max Intensity]");
selectWindow("test");
close();
rename("test");

*/
//Time series first frame
rename("test");
run("Duplicate...", "duplicate frames=1");
selectWindow("test");
close();
selectWindow("test-1");
rename("test");



Stack.setDisplayMode("composite"); 
run("Split Channels");

//substracting background
selectWindow("C2-test");
run("Enhance Contrast", "saturated=0.35");
setTool("oval");
waitForUser("Create an ROI to substract background");
roiManager("Add");
run("Measure");
run("Select None");
n = getResult("Mean", 0);
run("Subtract...", "value="+n+" stack");
run("Clear Results");
selectWindow("C1-test");
run("Restore Selection");
run("Measure");
run("Select None");
a = getResult("Mean", 0);
run("Subtract...", "value="+a+" stack");
run("Clear Results");
//selecting yeast cells
selectWindow("C1-test");
run("Duplicate...", " ");
run("Merge Channels...", "c1=C1-test c2=C2-test create");
rename("test");
selectWindow("C1-test-1");
run("Enhance Contrast", "saturated=0.35");
roiManager("reset");
roiManager("Show All");
waitForUser("Add yeast cell of interest to ROI manager");
roiManager("Save",  dir2+list[i] + " RoiSet.zip");
run("Close");

n = roiManager("count");
for (j = 0; j < n; j++) {
selectWindow("test");
roiManager("Select", j);
run("Duplicate...", "duplicate");
setBackgroundColor(0, 0, 0);
run("Clear Outside");
run("Split Channels");

run("Enhance Contrast", "saturated=0.35");
run("Tile");
selectWindow("test");
selectWindow("C1-test-1");
selectWindow("C2-test-1");

  Dialog.create("Radio Buttons");
  items = newArray("Tubular", "Ringo", "Other");
  Dialog.addChoice("Type:", items);
  Dialog.show;
  items = Dialog.getChoice();

selectWindow("C1-test-1");
run("Enhance Contrast", "saturated=0.35");
run("Duplicate...", " ");
run("Smooth");
run("Smooth");
run("Gaussian Blur...", "sigma=1");
setAutoThreshold("Default dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Erode");
run("Close-");
run("Fill Holes");
run("Create Selection");
selectWindow("C2-test-1");
rename(""+title+"_ROI-"+j+"_"+items+"");
run("Restore Selection");
run("Measure");
//saveAs("Tiff", dir2+list[i] + " Mask_"+j+"");
close();
close();
close();
}
run("Close All");
selectWindow("Results");
saveAs("Results", dir2+list[i] + " Result.txt");
run("Clear Results");
}