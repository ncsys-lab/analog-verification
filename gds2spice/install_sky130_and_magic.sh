#Clone Magic
git clone https://github.com/RTimothyEdwards/magic.git

cd magic
git checkout magic-8.3

# compile & install magic
sudo ./configure
sudo make
sudo make install

cd ..

#---Install skywater pdk---
git clone https://github.com/google/skywater-pdk
cd skywater-pdk

# initialise pdk
git submodule init libraries/sky130_fd_pr/latest libraries/sky130_fd_sc_hd/latest libraries/sky130_fd_sc_hdll/latest libraries/sky130_fd_sc_hs/latest libraries/sky130_fd_sc_ms/latest libraries/sky130_fd_sc_ls/latest 
ibraries/sky130_fd_sc_lp/latest  libraries/sky130_fd_sc_hvl/latest


git submodule update
sudo make timing

cd ..

#---Download Open PDKs---
git clone https://github.com/RTimothyEdwards/open_pdks.git

cd open_pdks
git checkout open_pdks-1.0


sudo ./configure --enable-sky130-pdk=/root/will/Desktop/AchourLab/skywater-pdk/libraries

cd sky130 # you should be in open_pdks root dir
sudo make
sudo make install



