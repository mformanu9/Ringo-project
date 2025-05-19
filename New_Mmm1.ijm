run("Close All");
run("Set Measurements...", "area mean standard min perimeter display redirect=None decimal=3");
run("Clear Results");
roiManager("reset");
run("Options...", "iterations=1 count=1 black do=Nothing");


dir1 = getDirectory("Choose Source Directory");
dir2 = getDirectory("Choose Destination Directory"); 
list = getFileList(dir1);
for (i=0; i<list.length; i++){ 
      showProgress(i+1, list.length); 
     open(dir1+list[i]);
    
path = dir1+list[i];     
print(path);

//plane selection
rename("test");
run("Duplicate...", "duplicate slices=1");
selectWindow("test");
close();
selectWindow("test-1");
rename("test");
run("Set Measurements...", "area mean standard min perimeter display redirect=None decimal=3");
run("Split Channels");
//background substraction
setTool("oval");
selectWindow("C1-test");
waitForUser("Select a ROI to substract background");
run("Measure");
m = getResult("Mean", 0);
run("Select None");
run("Subtract...", "value="+m+"");
run("Clear Results");
selectWindow("C2-test");
run("Restore Selection");
run("Measure");
run("Select None");
a = getResult("Mean", 0);
run("Subtract...", "value="+a+" stack");
run("Clear Results");

selectWindow("C2-test");
run("Duplicate...", "title=Mmm1_Binary");
run("Smooth");
run("Smooth");
run("Smooth");
run("Duplicate...", " ");
selectWindow("Mmm1_Binary");
run("Duplicate...", " ");
run("Gaussian Blur...", "sigma=7");
selectWindow("Mmm1_Binary-1");
run("Gaussian Blur...", "sigma=5");
imageCalculator("Subtract create", "Mmm1_Binary-1","Mmm1_Binary-2");
selectWindow("Result of Mmm1_Binary-1");
selectWindow("Mmm1_Binary-1");
close();
selectWindow("Mmm1_Binary-2");
close();
selectWindow("Mmm1_Binary");
close();
selectWindow("Result of Mmm1_Binary-1");
rename("Mmm1_Binary");

setThreshold(200, 65535);
run("Convert to Mask");
run("Open");


selectWindow("C1-test");
run("Duplicate...", "title=Tom70_Binary");
run("Smooth");
run("Smooth");
run("Smooth");
run("Gaussian Blur...", "sigma=5");
setAutoThreshold("Otsu dark");
run("Convert to Mask");
run("Open");

selectWindow("C2-test");
rename("Mmm1");
selectWindow("C1-test");
rename("Tom70");

//Adding cells to analyze
selectWindow("Tom70");
run("ROI Manager...");
run("Enhance Contrast", "saturated=0.35");
roiManager("Show All with labels");
waitForUser("Add yeast cell of interest to ROI manager");
roiManager("Save",  dir2+list[i] + "RoiSet.zip");

//Quantification of Mmm1
t = roiManager("count");
for (j = 0; j < t; j++) {
    selectWindow("Tom70");
    roiManager("select", j);
run("Set Measurements...", "area mean standard min perimeter display redirect=None decimal=3");
run("Duplicate...", "title=Tom70_"+j+"");
run("Select None");
selectWindow("Tom70_Binary");
roiManager("Select", j);
run("Duplicate...", "title=Tom70_Binary_"+j+"");
run("Clear Outside");
run("Select None");
selectWindow("Mmm1");
roiManager("Select", j);
run("Duplicate...", "title=Mmm1_"+j+"");
run("Select None");
selectWindow("Mmm1_Binary");
roiManager("Select", j);
run("Duplicate...", "title=Mmm1_Binary_"+j+"");
run("Clear Outside");
run("Select None");
run("Select None");

selectWindow("Mmm1_Binary_"+j+"");
run("Set Measurements...", "area mean standard min perimeter display redirect=Mmm1_"+j+" decimal=3");
run("Analyze Particles...", "summarize");
selectWindow("Tom70_Binary_"+j+"");
run("Create Selection");
run("Set Measurements...", "area mean standard min perimeter display redirect=None decimal=3");
run("Measure");
selectWindow("Tom70_"+j+"");
close();
selectWindow("Mmm1_"+j+"");
close();
selectWindow("Mmm1_Binary_"+j+"");
close();
selectWindow("Tom70_Binary_"+j+"");
close();
}
roiManager("reset");
selectWindow("Summary");
saveAs("Text", dir2+list[i] + " Summary.txt");
run("Close");
saveAs("Results", dir2+list[i] + " Result.txt");
run("Clear Results");
run("Close All");
}