run("Close All");
run("Clear Results");
roiManager("reset");

dir1 = getDirectory("Choose Source Directory "); 
dir2 = getDirectory("Choose Destination Directory"); 
list = getFileList(dir1);

types = newArray("1.323", "1.073");
  Dialog.create("Example Dialog");
  Dialog.addChoice("Type:", types);
  Dialog.show();
  type = Dialog.getChoice();

for (i=0; i<list.length; i++){ 
      showProgress(i+1, list.length); 
     open(dir1+list[i]);

path = dir1+list[i];   
print(path);  

title = getTitle();
rename("test");
run("Set Scale...", "distance=1 known="+type+" unit=nm global");
run("Z Project...", "projection=[Average Intensity]");
selectWindow("test");
setTool("oval");
waitForUser("Create region occupied by mitochondria ");
roiManager("Add");
roiManager("Save",  dir2+list[i] + "RoiSet.zip");
selectWindow("AVG_test");
roiManager("Select", 0);
run("Draw", "slice");
saveAs("Tiff", dir2+list[i] + "_Zprojection.tif");
rename("AVG_test");
selectWindow("test");
rename("test_area");
roiManager("Select", 0);
run("Measure");
rename("test_Length");
setTool("line");
waitForUser("Measure thickness of mitochondria");
rename("test_intermembrane space");
waitForUser("Measure intermembrane space of mitochondria");
rename("test_cristae");
run("Original Scale");
setTool("line");
waitForUser("Measure cristae thickness of mitochondria");
saveAs("Results", dir2+list[i] + " Result.txt");

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

waitForUser("Copy the values on excel sheet");
run("Clear Results");
roiManager("Save",  dir2+list[i] + "RoiSet.zip");
roiManager("reset");
run("Close All");
}



