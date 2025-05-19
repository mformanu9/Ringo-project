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
run("Enhance Contrast", "saturated=0.35");
waitForUser("Select a ROI to substract background");
roiManager("Add");
run("Measure");
m = getResult("Mean", 0);
run("Select None");
run("Subtract...", "value="+m+"");
run("Clear Results");

selectWindow("C2-test");
roiManager("Select", 0);
run("Measure");
run("Select None");
n = getResult("Mean", 0);
run("Subtract...", "value="+n+" stack");
run("Clear Results");

selectWindow("C2-test");
run("Duplicate...", "title=mtDNA_Binary");
run("Smooth");
run("Smooth");
run("Smooth");
run("Duplicate...", " ");
selectWindow("mtDNA_Binary");
run("Duplicate...", " ");
run("Gaussian Blur...", "sigma=7");
selectWindow("mtDNA_Binary-1");
run("Gaussian Blur...", "sigma=5");
imageCalculator("Subtract create", "mtDNA_Binary-1","mtDNA_Binary-2");
selectWindow("Result of mtDNA_Binary-1");
selectWindow("mtDNA_Binary-1");
close();
selectWindow("mtDNA_Binary-2");
close();
selectWindow("mtDNA_Binary");
close();
selectWindow("Result of mtDNA_Binary-1");
rename("mtDNA_Binary");
setAutoThreshold("Otsu dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Open");
run("Watershed");
run("Open");



selectWindow("C1-test");
run("Duplicate...", "title=Mito_Binary");

selectWindow("C2-test");
rename("mtDNA");
selectWindow("C1-test");
rename("Mito");
run("Tile");


run("Merge Channels...", "c1=Mito c2=mtDNA create keep");
run("Enhance Contrast", "saturated=0.35");
setSlice(2);
run("Enhance Contrast", "saturated=0.35");
saveAs("Tiff", dir2+list[i] + "_Composite");
run("Close");

roiManager("reset");
selectImage("Mito_Binary");
run("Enhance Contrast", "saturated=0.35");
roiManager("Show All");
waitForUser("Add yeast cell of interest to ROI manager");

n = roiManager('count');
for (k = 0; k < n; k++) {
    roiManager('select', k);
    roiManager("Rename", "ROI_"+k+"");
}

n = roiManager('count');
for (j = 0; j < n; j++) {
run("Set Measurements...", "area mean standard min perimeter display redirect=mtDNA decimal=3");
selectImage("mtDNA_Binary");
roiManager("Select", j);
run("Analyze Particles...", "summarize");
}
selectWindow("Summary");
saveAs("Text", dir2+list[i] + " mtDNA-Summary.txt");
run("Close");


run("Set Measurements...", "area mean standard min perimeter display redirect=None decimal=3");
n = roiManager('count');
for (j = 0; j < n; j++) {
selectImage("Mito_Binary");
roiManager("Select", j);
run("Duplicate...", " ");
setBackgroundColor(0, 0, 0);
run("Clear Outside");
run("Select None");
run("Enhance Contrast", "saturated=0.35");
run("Smooth");
run("Smooth");
run("Smooth");
run("Gaussian Blur...", "sigma=3");
setAutoThreshold("Default dark");
run("Threshold...");
waitForUser("Apply threshold");
run("Convert to Mask");
run("Create Selection");
run("Measure");
selectImage("mtDNA_Binary");
run("Duplicate...", " ");
selectImage("mtDNA_Binary-1");
run("Select None");
selectImage("Mito_Binary-1");
selectImage("mtDNA_Binary-1");
run("Restore Selection");
run("Analyze Particles...", "summarize");
selectImage("Mito_Binary-1");
close();
close();
}
selectWindow("Results");
saveAs("Results", dir2+list[i] + " Matrix-Result.txt");
run("Clear Results");
run("Close All");
selectWindow("Summary");
saveAs("Text", dir2+list[i] + " mtDNAonMitochondria-Summary.txt");
run("Close");
}

