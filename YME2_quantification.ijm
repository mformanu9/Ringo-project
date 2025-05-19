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
run("Duplicate...", "duplicate frames=1");
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

//Adding cells to analyze
selectWindow("C1-test");
run("Enhance Contrast", "saturated=0.35");
run("ROI Manager...");
roiManager("Show All with labels");
waitForUser("Add yeast cell of interest to ROI manager");
roiManager("Save",  dir2+list[i] + "RoiSet.zip");

//Quantification of YME2
t = roiManager("count");
for (j = 0; j < t; j++) {
    roiManager("select", j);
    selectWindow("C1-test");
    roiManager("select", j);

run("Duplicate...", "title=ROI"+j+"");
run("Duplicate...", "title=ROI"+j+"-Int");
run("Select None");
run("Smooth");
run("Smooth");
run("Smooth");
run("Gaussian Blur...", "sigma=10");
run("Enhance Contrast", "saturated=0.35");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Restore Selection");
run("Clear Outside");
run("Select None");
run("Create Selection");
selectWindow("ROI"+j+"");
run("Restore Selection");
run("Measure");
run("Select None");
run("Duplicate...", "title=ROI"+j+"-Mask");
run("Smooth");
run("Smooth");
run("Gaussian Blur...", "sigma=3");
run("Duplicate...", " ");
run("Gaussian Blur...", "sigma=5");
imageCalculator("Subtract create", "ROI"+j+"-Mask","ROI"+j+"-Mask-1");
selectWindow("Result of ROI"+j+"-Mask");
selectWindow("ROI"+j+"-Mask-1");
close();
selectWindow("ROI"+j+"-Mask");
close();
selectWindow("Result of ROI"+j+"-Mask");
rename("ROI"+j+"-Mask");
setThreshold(15, 65535);
run("Convert to Mask");
run("Restore Selection");
run("Clear Outside");
run("Analyze Particles...", "summarize");
close();
selectWindow("ROI"+j+"");
close();
selectWindow("ROI"+j+"-Int");
close();

}
selectWindow("Summary");
saveAs("Text", dir2+list[i] + " Summary.txt");
run("Close");
roiManager("reset");
saveAs("Results", dir2+list[i] + " Result.txt");
run("Clear Results");
run("Close All");
}

