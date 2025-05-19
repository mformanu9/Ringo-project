run("Close All");
roiManager("reset");
run("Clear Results");
run("Set Measurements...", "area integrated display redirect=None decimal=2");
run("Colors...", "foreground=black background=black selection=red");
media = newArray("YPD", "YPG");
  Dialog.create("Image Info");
  Dialog.addNumber("Strain number:", 1950);
  Dialog.addChoice("Type:", media);
  Dialog.addNumber("Cell number:", 001);
  Dialog.show();
  strain = Dialog.getNumber();
  media = Dialog.getChoice();
  cell = Dialog.getNumber();
  
Path = File.openDialog("Open low resolution image (.tif)");
dir1 = File.getDirectory(Path);
dir2 = dir1+"Analysis_Cell"+File.separator;
File.makeDirectory(dir2);
open(Path);
rename("LR");
//rename("LR_"+strain+"_"+media+"_"+cell+"");
HR = File.openDialog("Open High resolution image (.tif)");
open(HR);
rename("HR_"+strain+"_"+media+"_"+cell+"");
run("Set Scale...", "distance=47.1698 known=1 unit=µm global");

selectWindow("LR");
run("Duplicate...", "title=LR-1");
run("Smooth");
run("Smooth");
run("Smooth");
run("Duplicate...", "title=LR-2");
run("Gaussian Blur...", "sigma=10");
selectWindow("LR-1");
run("Gaussian Blur...", "sigma=7");
imageCalculator("Subtract create", "LR-1","LR-2");
selectWindow("Result of LR-1");
run("Threshold...");
waitForUser("Apply threshold");
selectWindow("LR-2");
close();
selectWindow("LR-1");
close();
selectWindow("Result of LR-1");
rename("LR_"+strain+"_"+media+"_"+cell+"");

selectWindow("LR");
close();

selectWindow("HR_"+strain+"_"+media+"_"+cell+"");
setTool("oval");
roiManager("Show All");
waitForUser("Select cell for measurement");
roiManager("Save",  dir2 + "RoiSet_"+strain+"_"+media+"_"+cell+".zip");


n = roiManager("count");
for (i = 0; i < n; i++) {
	selectWindow("HR_"+strain+"_"+media+"_"+cell+"");
    roiManager("select", i);   
run("Duplicate...", "title=HR_"+strain+"_"+media+"_"+cell+"_ROI-"+i+"");
run("Clear Outside");
rename("HR_"+strain+"_"+media+"_"+cell+"_ROI-"+i+"_Cell");
run("Measure");
run("Select None");
selectWindow("LR_"+strain+"_"+media+"_"+cell+"");
roiManager("Select", 0);
run("Duplicate...", " ");
run("Select None");
run("Create Selection");
selectWindow("HR_"+strain+"_"+media+"_"+cell+"_ROI-"+i+"_Cell");
run("Restore Selection");
waitForUser("Select Mitochondria");
rename("HR_"+strain+"_"+media+"_"+cell+"_ROI-"+i+"_Mito");
run("Measure");
run("Select None");
setTool("oval");
waitForUser("Select Nucleus");
rename("HR_"+strain+"_"+media+"_"+cell+"_ROI-"+i+"_Nuc");
run("Measure");
close();
close();
}
selectWindow("Results"); 
saveAs("Text", dir2 + "Results_"+strain+"_"+media+"_"+cell+".txt");
run("Clear Results");
run("Close All");