#!bin/bash
# save the contents of image directory to pseudo Tei XML file part
echo '<text>'
echo '<body>'
for THIS in *; 
do echo '<pb facs="'${THIS}'"/>'; 
done
echo '</body>'
echo '</text>'