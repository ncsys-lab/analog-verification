* Automatically generated file.
.include /data/ctle.sp
X0 vinp vinn voutp voutn v_fz vdd vss ctle
.subckt inout_sw_mod sw_p sw_n ctl_p ctl_n
    Gs sw_p sw_n cur='V(sw_p, sw_n)*(0.999999999*V(ctl_p, ctl_n)+1e-09)'
.ends
X1 __vdd_v vdd __vdd_s 0 inout_sw_mod
V2 __vdd_v 0 DC 1.8 PWL(0 1.8 3.999999999999989e-07 1.8)
V3 __vdd_s 0 DC 1 PWL(0 1 3.999999999999989e-07 1)
X4 __vss_v vss __vss_s 0 inout_sw_mod
V5 __vss_v 0 DC 0 PWL(0 0 3.999999999999989e-07 0)
V6 __vss_s 0 DC 1 PWL(0 1 3.999999999999989e-07 1)
X7 __v_fz_v v_fz __v_fz_s 0 inout_sw_mod
V8 __v_fz_v 0 DC 0.42579150855767894 PWL(0 0.42579150855767894 4e-09 0.42579150855767894 4.01e-09 0.4159636229631016 8e-09 0.4159636229631016 8.01e-09 0.6041040408440359 1.2e-08 0.6041040408440359 1.201e-08 0.538069601798459 1.6e-08 0.538069601798459 1.6010000000000002e-08 0.6765458231078825 2.0000000000000004e-08 0.6765458231078825 2.0010000000000005e-08 0.8589408117068207 2.4000000000000006e-08 0.8589408117068207 2.4010000000000008e-08 0.7044901921444251 2.800000000000001e-08 0.7044901921444251 2.801000000000001e-08 0.8310168359533179 3.200000000000001e-08 0.8310168359533179 3.201000000000001e-08 0.9216795631587303 3.6000000000000005e-08 0.9216795631587303 3.601e-08 1.0314289061704995 4e-08 1.0314289061704995 4.001e-08 0.9305496276710397 4.4e-08 0.9305496276710397 4.4009999999999995e-08 1.0504805513091517 4.799999999999999e-08 1.0504805513091517 4.800999999999999e-08 1.2930917004214728 5.199999999999999e-08 1.2930917004214728 5.200999999999999e-08 1.2720093700798603 5.5999999999999985e-08 1.2720093700798603 5.6009999999999983e-08 1.2491398939774605 5.999999999999998e-08 1.2491398939774605 6.000999999999998e-08 1.3587703100996165 6.399999999999999e-08 1.3587703100996165 6.400999999999999e-08 0.5615336565633797 6.8e-08 0.5615336565633797 6.801e-08 0.5142480172229986 7.200000000000001e-08 0.5142480172229986 7.201000000000001e-08 0.45715896392332994 7.600000000000002e-08 0.45715896392332994 7.601000000000002e-08 0.5738796967223835 8.000000000000003e-08 0.5738796967223835 8.001000000000003e-08 0.8268579630079971 8.400000000000004e-08 0.8268579630079971 8.401000000000004e-08 0.8808630203061316 8.800000000000005e-08 0.8808630203061316 8.801000000000004e-08 0.7134851936453652 9.200000000000006e-08 0.7134851936453652 9.201000000000005e-08 0.7227350905685586 9.600000000000007e-08 0.7227350905685586 9.601000000000006e-08 1.016393937955737 1.0000000000000007e-07 1.016393937955737 1.0001000000000007e-07 1.1291855558223645 1.0400000000000008e-07 1.1291855558223645 1.0401000000000008e-07 1.1423748424064606 1.080000000000001e-07 1.1423748424064606 1.0801000000000009e-07 1.133881216254262 1.120000000000001e-07 1.133881216254262 1.120100000000001e-07 1.388094757144126 1.1600000000000011e-07 1.388094757144126 1.1601000000000011e-07 1.2086820507313751 1.2000000000000012e-07 1.2086820507313751 1.2001000000000013e-07 1.175923149045624 1.240000000000001e-07 1.175923149045624 1.2401000000000012e-07 1.2296353012558534 1.280000000000001e-07 1.2296353012558534 1.280100000000001e-07 0.4488263974493924 1.3200000000000007e-07 0.4488263974493924 1.3201000000000008e-07 0.48645347782546966 1.3600000000000005e-07 0.48645347782546966 1.3601000000000006e-07 0.5235928778907617 1.4000000000000004e-07 0.5235928778907617 1.4001000000000005e-07 0.40773788752553614 1.4400000000000002e-07 0.40773788752553614 1.4401000000000003e-07 0.6854388909273443 1.48e-07 0.6854388909273443 1.4801e-07 0.739849384214202 1.5199999999999998e-07 0.739849384214202 1.5201e-07 0.789386237963558 1.5599999999999997e-07 0.789386237963558 1.5600999999999998e-07 0.8982720338406904 1.5999999999999995e-07 0.8982720338406904 1.6000999999999996e-07 0.9898058230700311 1.6399999999999993e-07 0.9898058230700311 1.6400999999999994e-07 0.9597737558453507 1.6799999999999992e-07 0.9597737558453507 1.6800999999999993e-07 1.0247869579356648 1.719999999999999e-07 1.0247869579356648 1.720099999999999e-07 0.9639344773709385 1.7599999999999988e-07 0.9639344773709385 1.760099999999999e-07 1.367850617725304 1.7999999999999986e-07 1.367850617725304 1.8000999999999988e-07 1.3784853080684145 1.8399999999999985e-07 1.3784853080684145 1.8400999999999986e-07 1.2504443098933493 1.8799999999999983e-07 1.2504443098933493 1.8800999999999984e-07 1.330720081183533 1.9199999999999981e-07 1.330720081183533 1.9200999999999982e-07 0.46207812015648175 1.959999999999998e-07 0.46207812015648175 1.960099999999998e-07 0.6379714226223281 1.9999999999999978e-07 0.6379714226223281 2.000099999999998e-07 0.5922599899905563 2.0399999999999976e-07 0.5922599899905563 2.0400999999999977e-07 0.621482617124907 2.0799999999999974e-07 0.621482617124907 2.0800999999999976e-07 0.8091747807275025 2.1199999999999973e-07 0.8091747807275025 2.1200999999999974e-07 0.874753486957899 2.159999999999997e-07 0.874753486957899 2.1600999999999972e-07 0.865795119919365 2.199999999999997e-07 0.865795119919365 2.200099999999997e-07 0.8198969721939755 2.2399999999999968e-07 0.8198969721939755 2.240099999999997e-07 1.0767346892604281 2.2799999999999966e-07 1.0767346892604281 2.2800999999999967e-07 1.0662227748017694 2.3199999999999964e-07 1.0662227748017694 2.3200999999999965e-07 1.1120229041051017 2.3599999999999963e-07 1.1120229041051017 2.3600999999999964e-07 1.1022361993467378 2.399999999999996e-07 1.1022361993467378 2.400099999999996e-07 1.1650656960267707 2.439999999999996e-07 1.1650656960267707 2.440099999999996e-07 1.3453453444442172 2.479999999999996e-07 1.3453453444442172 2.480099999999996e-07 1.192183639316329 2.5199999999999956e-07 1.192183639316329 2.5200999999999957e-07 1.329175002695897 2.5599999999999954e-07 1.329175002695897 2.5600999999999955e-07 0.4303418314975073 2.599999999999995e-07 0.4303418314975073 2.6000999999999953e-07 0.5536256968289383 2.639999999999995e-07 0.5536256968289383 2.640099999999995e-07 1.2308514101028343 2.679999999999995e-07 1.2308514101028343 2.680099999999995e-07 0.6548665200066175 2.7199999999999947e-07 0.6548665200066175 2.720099999999995e-07 1.2851247464865136 2.7599999999999945e-07 1.2851247464865136 2.7600999999999947e-07 1.2619585267183882 2.7999999999999944e-07 1.2619585267183882 2.8000999999999945e-07 0.6187428715201334 2.839999999999994e-07 0.6187428715201334 2.8400999999999943e-07 0.919040723368889 2.879999999999994e-07 0.919040723368889 2.880099999999994e-07 0.8471558665931966 2.919999999999994e-07 0.8471558665931966 2.920099999999994e-07 0.7576666993037173 2.9599999999999937e-07 0.7576666993037173 2.960099999999994e-07 0.7491279052875304 2.9999999999999935e-07 0.7491279052875304 3.0000999999999936e-07 1.1561299951089516 3.0399999999999933e-07 1.1561299951089516 3.0400999999999935e-07 1.0013325474734156 3.079999999999993e-07 1.0013325474734156 3.0800999999999933e-07 1.3037198815641915 3.119999999999993e-07 1.3037198815641915 3.120099999999993e-07 0.7693618807870362 3.159999999999993e-07 0.7693618807870362 3.160099999999993e-07 0.47020099993973485 3.1999999999999927e-07 0.47020099993973485 3.200099999999993e-07 1.3915846574442385 3.2399999999999925e-07 1.3915846574442385 3.2400999999999926e-07 1.0896847339709383 3.2799999999999923e-07 1.0896847339709383 3.2800999999999924e-07 0.9783126287654238 3.319999999999992e-07 0.9783126287654238 3.320099999999992e-07 1.2170358948574302 3.359999999999992e-07 1.2170358948574302 3.360099999999992e-07 1.318990177944515 3.399999999999992e-07 1.318990177944515 3.400099999999992e-07 0.6901318331250015 3.4399999999999916e-07 0.6901318331250015 3.440099999999992e-07 0.6695106611690407 3.4799999999999915e-07 0.6695106611690407 3.4800999999999916e-07 1.1891996412983092 3.5199999999999913e-07 1.1891996412983092 3.5200999999999914e-07 0.549282443037394 3.559999999999991e-07 0.549282443037394 3.560099999999991e-07 0.6494792831724051 3.599999999999991e-07 0.6494792831724051 3.600099999999991e-07 1.0926233579232192 3.639999999999991e-07 1.0926233579232192 3.640099999999991e-07 0.5812177126311234 3.6799999999999906e-07 0.5812177126311234 3.6800999999999907e-07 0.9473132640234526 3.7199999999999904e-07 0.9473132640234526 3.7200999999999905e-07 0.7969376191498785 3.75999999999999e-07 0.7969376191498785 3.7600999999999904e-07 1.0448419176420265 3.79999999999999e-07 1.0448419176420265 3.80009999999999e-07 0.5068214070277557 3.83999999999999e-07 0.5068214070277557 3.84009999999999e-07 0.4987665194776813 3.87999999999999e-07 0.4987665194776813 3.88009999999999e-07 0.9982339759182465 3.9199999999999896e-07 0.9982339759182465 3.9200999999999897e-07 0.7782549020984999 3.9599999999999894e-07 0.7782549020984999 3.9600999999999895e-07 0.9084750748554299 3.999999999999989e-07 0.9084750748554299)
V9 __v_fz_s 0 DC 1 PWL(0 1 4e-09 1 4.01e-09 1 8e-09 1 8.01e-09 1 1.2e-08 1 1.201e-08 1 1.6e-08 1 1.6010000000000002e-08 1 2.0000000000000004e-08 1 2.0010000000000005e-08 1 2.4000000000000006e-08 1 2.4010000000000008e-08 1 2.800000000000001e-08 1 2.801000000000001e-08 1 3.200000000000001e-08 1 3.201000000000001e-08 1 3.6000000000000005e-08 1 3.601e-08 1 4e-08 1 4.001e-08 1 4.4e-08 1 4.4009999999999995e-08 1 4.799999999999999e-08 1 4.800999999999999e-08 1 5.199999999999999e-08 1 5.200999999999999e-08 1 5.5999999999999985e-08 1 5.6009999999999983e-08 1 5.999999999999998e-08 1 6.000999999999998e-08 1 6.399999999999999e-08 1 6.400999999999999e-08 1 6.8e-08 1 6.801e-08 1 7.200000000000001e-08 1 7.201000000000001e-08 1 7.600000000000002e-08 1 7.601000000000002e-08 1 8.000000000000003e-08 1 8.001000000000003e-08 1 8.400000000000004e-08 1 8.401000000000004e-08 1 8.800000000000005e-08 1 8.801000000000004e-08 1 9.200000000000006e-08 1 9.201000000000005e-08 1 9.600000000000007e-08 1 9.601000000000006e-08 1 1.0000000000000007e-07 1 1.0001000000000007e-07 1 1.0400000000000008e-07 1 1.0401000000000008e-07 1 1.080000000000001e-07 1 1.0801000000000009e-07 1 1.120000000000001e-07 1 1.120100000000001e-07 1 1.1600000000000011e-07 1 1.1601000000000011e-07 1 1.2000000000000012e-07 1 1.2001000000000013e-07 1 1.240000000000001e-07 1 1.2401000000000012e-07 1 1.280000000000001e-07 1 1.280100000000001e-07 1 1.3200000000000007e-07 1 1.3201000000000008e-07 1 1.3600000000000005e-07 1 1.3601000000000006e-07 1 1.4000000000000004e-07 1 1.4001000000000005e-07 1 1.4400000000000002e-07 1 1.4401000000000003e-07 1 1.48e-07 1 1.4801e-07 1 1.5199999999999998e-07 1 1.5201e-07 1 1.5599999999999997e-07 1 1.5600999999999998e-07 1 1.5999999999999995e-07 1 1.6000999999999996e-07 1 1.6399999999999993e-07 1 1.6400999999999994e-07 1 1.6799999999999992e-07 1 1.6800999999999993e-07 1 1.719999999999999e-07 1 1.720099999999999e-07 1 1.7599999999999988e-07 1 1.760099999999999e-07 1 1.7999999999999986e-07 1 1.8000999999999988e-07 1 1.8399999999999985e-07 1 1.8400999999999986e-07 1 1.8799999999999983e-07 1 1.8800999999999984e-07 1 1.9199999999999981e-07 1 1.9200999999999982e-07 1 1.959999999999998e-07 1 1.960099999999998e-07 1 1.9999999999999978e-07 1 2.000099999999998e-07 1 2.0399999999999976e-07 1 2.0400999999999977e-07 1 2.0799999999999974e-07 1 2.0800999999999976e-07 1 2.1199999999999973e-07 1 2.1200999999999974e-07 1 2.159999999999997e-07 1 2.1600999999999972e-07 1 2.199999999999997e-07 1 2.200099999999997e-07 1 2.2399999999999968e-07 1 2.240099999999997e-07 1 2.2799999999999966e-07 1 2.2800999999999967e-07 1 2.3199999999999964e-07 1 2.3200999999999965e-07 1 2.3599999999999963e-07 1 2.3600999999999964e-07 1 2.399999999999996e-07 1 2.400099999999996e-07 1 2.439999999999996e-07 1 2.440099999999996e-07 1 2.479999999999996e-07 1 2.480099999999996e-07 1 2.5199999999999956e-07 1 2.5200999999999957e-07 1 2.5599999999999954e-07 1 2.5600999999999955e-07 1 2.599999999999995e-07 1 2.6000999999999953e-07 1 2.639999999999995e-07 1 2.640099999999995e-07 1 2.679999999999995e-07 1 2.680099999999995e-07 1 2.7199999999999947e-07 1 2.720099999999995e-07 1 2.7599999999999945e-07 1 2.7600999999999947e-07 1 2.7999999999999944e-07 1 2.8000999999999945e-07 1 2.839999999999994e-07 1 2.8400999999999943e-07 1 2.879999999999994e-07 1 2.880099999999994e-07 1 2.919999999999994e-07 1 2.920099999999994e-07 1 2.9599999999999937e-07 1 2.960099999999994e-07 1 2.9999999999999935e-07 1 3.0000999999999936e-07 1 3.0399999999999933e-07 1 3.0400999999999935e-07 1 3.079999999999993e-07 1 3.0800999999999933e-07 1 3.119999999999993e-07 1 3.120099999999993e-07 1 3.159999999999993e-07 1 3.160099999999993e-07 1 3.1999999999999927e-07 1 3.200099999999993e-07 1 3.2399999999999925e-07 1 3.2400999999999926e-07 1 3.2799999999999923e-07 1 3.2800999999999924e-07 1 3.319999999999992e-07 1 3.320099999999992e-07 1 3.359999999999992e-07 1 3.360099999999992e-07 1 3.399999999999992e-07 1 3.400099999999992e-07 1 3.4399999999999916e-07 1 3.440099999999992e-07 1 3.4799999999999915e-07 1 3.4800999999999916e-07 1 3.5199999999999913e-07 1 3.5200999999999914e-07 1 3.559999999999991e-07 1 3.560099999999991e-07 1 3.599999999999991e-07 1 3.600099999999991e-07 1 3.639999999999991e-07 1 3.640099999999991e-07 1 3.6799999999999906e-07 1 3.6800999999999907e-07 1 3.7199999999999904e-07 1 3.7200999999999905e-07 1 3.75999999999999e-07 1 3.7600999999999904e-07 1 3.79999999999999e-07 1 3.80009999999999e-07 1 3.83999999999999e-07 1 3.84009999999999e-07 1 3.87999999999999e-07 1 3.88009999999999e-07 1 3.9199999999999896e-07 1 3.9200999999999897e-07 1 3.9599999999999894e-07 1 3.9600999999999895e-07 1 3.999999999999989e-07 1)
X10 __vinp_v vinp __vinp_s 0 inout_sw_mod
V11 __vinp_v 0 DC 0 PWL(0 0 2e-09 0 2.0100000000000003e-09 0.8829013291543515 6.000000000000001e-09 0.8829013291543515 6.0100000000000005e-09 0.8943795549306924 1e-08 0.8943795549306924 1.001e-08 0.9211210155268267 1.4e-08 0.9211210155268267 1.401e-08 0.9193997429756116 1.8000000000000002e-08 0.9193997429756116 1.8010000000000004e-08 0.8798857827484434 2.2000000000000005e-08 0.8798857827484434 2.2010000000000007e-08 0.9089545844747084 2.6000000000000008e-08 0.9089545844747084 2.601000000000001e-08 0.9133224539537527 3.000000000000001e-08 0.9133224539537527 3.001000000000001e-08 0.9308985607176143 3.4000000000000007e-08 0.9308985607176143 3.4010000000000005e-08 0.8934477280493488 3.8e-08 0.8934477280493488 3.801e-08 0.8969181986559008 4.2e-08 0.8969181986559008 4.201e-08 0.9172996753417376 4.5999999999999995e-08 0.9172996753417376 4.600999999999999e-08 0.9270112151963888 4.999999999999999e-08 0.9270112151963888 5.000999999999999e-08 0.8956131465198622 5.399999999999999e-08 0.8956131465198622 5.4009999999999985e-08 0.9016416710037909 5.7999999999999983e-08 0.9016416710037909 5.800999999999998e-08 0.9070685452643826 6.199999999999999e-08 0.9070685452643826 6.200999999999998e-08 0.9165011811419584 6.6e-08 0.9165011811419584 6.601e-08 0.8915235737095142 7e-08 0.8915235737095142 7.001e-08 0.9110153158254857 7.400000000000001e-08 0.9110153158254857 7.401000000000001e-08 0.9303030509452562 7.800000000000002e-08 0.9303030509452562 7.801000000000002e-08 0.9321305775449731 8.200000000000003e-08 0.9321305775449731 8.201000000000003e-08 0.8964429119558747 8.600000000000004e-08 0.8964429119558747 8.601000000000004e-08 0.9085950842230125 9.000000000000005e-08 0.9085950842230125 9.001000000000005e-08 0.9227369197126444 9.400000000000006e-08 0.9227369197126444 9.401000000000006e-08 0.9388495586298756 9.800000000000007e-08 0.9388495586298756 9.801000000000007e-08 0.8909157936786499 1.0200000000000008e-07 0.8909157936786499 1.0201000000000008e-07 0.9216483422359444 1.0600000000000009e-07 0.9216483422359444 1.0601000000000009e-07 0.9226843661638409 1.100000000000001e-07 0.9226843661638409 1.100100000000001e-07 0.9388877499099448 1.1400000000000011e-07 0.9388877499099448 1.140100000000001e-07 0.9017523741701194 1.1800000000000012e-07 0.9017523741701194 1.1801000000000012e-07 0.9136303036474682 1.220000000000001e-07 0.9136303036474682 1.2201000000000012e-07 0.9228774940296655 1.260000000000001e-07 0.9228774940296655 1.260100000000001e-07 0.9373936363090906 1.3000000000000008e-07 0.9373936363090906 1.300100000000001e-07 0.9107218031475081 1.3400000000000006e-07 0.9107218031475081 1.3401000000000007e-07 0.9181780600152947 1.3800000000000004e-07 0.9181780600152947 1.3801000000000006e-07 0.9400574026245547 1.4200000000000003e-07 0.9400574026245547 1.4201000000000004e-07 0.9410864320676501 1.46e-07 0.9410864320676501 1.4601000000000002e-07 0.9094338236679236 1.5e-07 0.9094338236679236 1.5001e-07 0.9308877683737221 1.5399999999999998e-07 0.9308877683737221 1.5401e-07 0.9373519329496199 1.5799999999999996e-07 0.9373519329496199 1.5800999999999997e-07 0.9505059867834947 1.6199999999999994e-07 0.9505059867834947 1.6200999999999995e-07 0.9048323472989565 1.6599999999999992e-07 0.9048323472989565 1.6600999999999994e-07 0.9300395208169281 1.699999999999999e-07 0.9300395208169281 1.7000999999999992e-07 0.9364702310740496 1.739999999999999e-07 0.9364702310740496 1.740099999999999e-07 0.9453412468289291 1.7799999999999987e-07 0.9453412468289291 1.7800999999999988e-07 0.9064964456259197 1.8199999999999986e-07 0.9064964456259197 1.8200999999999987e-07 0.9202650517535519 1.8599999999999984e-07 0.9202650517535519 1.8600999999999985e-07 0.9482548040278566 1.8999999999999982e-07 0.9482548040278566 1.9000999999999983e-07 0.9569829513329119 1.939999999999998e-07 0.9569829513329119 1.9400999999999982e-07 0.9240495886980588 1.979999999999998e-07 0.9240495886980588 1.980099999999998e-07 0.9469954276453191 2.0199999999999977e-07 0.9469954276453191 2.0200999999999978e-07 0.9500675605070658 2.0599999999999975e-07 0.9500675605070658 2.0600999999999976e-07 0.9659995884326432 2.0999999999999974e-07 0.9659995884326432 2.1000999999999975e-07 0.9264844822544296 2.1399999999999972e-07 0.9264844822544296 2.1400999999999973e-07 0.9371742830356469 2.179999999999997e-07 0.9371742830356469 2.1800999999999971e-07 0.9572354499310873 2.2199999999999969e-07 0.9572354499310873 2.220099999999997e-07 0.9521666924517909 2.2599999999999967e-07 0.9521666924517909 2.2600999999999968e-07 0.9255652043042756 2.2999999999999965e-07 0.9255652043042756 2.3000999999999966e-07 0.9344687575593579 2.3399999999999963e-07 0.9344687575593579 2.3400999999999964e-07 0.9493006872305051 2.3799999999999962e-07 0.9493006872305051 2.3800999999999963e-07 0.951595017711322 2.419999999999996e-07 0.951595017711322 2.420099999999996e-07 0.9337461150103922 2.459999999999996e-07 0.9337461150103922 2.460099999999996e-07 0.9389508603703491 2.4999999999999957e-07 0.9389508603703491 2.500099999999996e-07 0.9541903000382457 2.5399999999999955e-07 0.9541903000382457 2.5400999999999956e-07 0.9645210848749715 2.5799999999999953e-07 0.9645210848749715 2.5800999999999954e-07 0.9275076199360208 2.619999999999995e-07 0.9275076199360208 2.620099999999995e-07 0.9575655557203261 2.659999999999995e-07 0.9575655557203261 2.660099999999995e-07 0.9016094234941612 2.699999999999995e-07 0.9016094234941612 2.700099999999995e-07 0.9627031445222565 2.7399999999999946e-07 0.9627031445222565 2.740099999999995e-07 0.898739402843675 2.7799999999999945e-07 0.898739402843675 2.7800999999999946e-07 0.9289516799230398 2.8199999999999943e-07 0.9289516799230398 2.8200999999999944e-07 0.9039738279166998 2.859999999999994e-07 0.9039738279166998 2.860099999999994e-07 0.9371720735166471 2.899999999999994e-07 0.9371720735166471 2.900099999999994e-07 0.9108103164010926 2.939999999999994e-07 0.9108103164010926 2.940099999999994e-07 0.9372371353294519 2.9799999999999936e-07 0.9372371353294519 2.9800999999999937e-07 0.9312604715059548 3.0199999999999934e-07 0.9312604715059548 3.0200999999999935e-07 0.9105040968275009 3.059999999999993e-07 0.9105040968275009 3.0600999999999934e-07 0.9207530589128333 3.099999999999993e-07 0.9207530589128333 3.100099999999993e-07 0.9477640547825408 3.139999999999993e-07 0.9477640547825408 3.140099999999993e-07 0.9153738599026537 3.179999999999993e-07 0.9153738599026537 3.180099999999993e-07 0.9340651770456582 3.2199999999999926e-07 0.9340651770456582 3.2200999999999927e-07 0.9471512456106912 3.2599999999999924e-07 0.9471512456106912 3.2600999999999925e-07 0.9102947338318677 3.299999999999992e-07 0.9102947338318677 3.3000999999999923e-07 0.9243365117308122 3.339999999999992e-07 0.9243365117308122 3.340099999999992e-07 0.9074147013648715 3.379999999999992e-07 0.9074147013648715 3.380099999999992e-07 0.9055137283820632 3.4199999999999917e-07 0.9055137283820632 3.420099999999992e-07 0.9279119845364124 3.4599999999999915e-07 0.9279119845364124 3.4600999999999917e-07 0.944885406223451 3.4999999999999914e-07 0.944885406223451 3.5000999999999915e-07 0.9091430134545092 3.539999999999991e-07 0.9091430134545092 3.5400999999999913e-07 0.925017910698614 3.579999999999991e-07 0.925017910698614 3.580099999999991e-07 0.8880143959099459 3.619999999999991e-07 0.8880143959099459 3.620099999999991e-07 0.9418523273112787 3.6599999999999907e-07 0.9418523273112787 3.660099999999991e-07 0.8800121472947023 3.6999999999999905e-07 0.8800121472947023 3.7000999999999906e-07 0.9399214223577138 3.7399999999999903e-07 0.9399214223577138 3.7400999999999905e-07 0.9671358936735879 3.77999999999999e-07 0.9671358936735879 3.7800999999999903e-07 0.9156611180394085 3.81999999999999e-07 0.9156611180394085 3.82009999999999e-07 0.9657922462883781 3.85999999999999e-07 0.9657922462883781 3.86009999999999e-07 0.9061915903418136 3.8999999999999897e-07 0.9061915903418136 3.90009999999999e-07 0.8988550996710531 3.9399999999999895e-07 0.8988550996710531 3.9400999999999896e-07 0.9422125005364486 3.9799999999999893e-07 0.9422125005364486 3.9800999999999894e-07 0.938762175209393 3.999999999999989e-07 0.938762175209393)
V12 __vinp_s 0 DC 1 PWL(0 1 2e-09 1 2.0100000000000003e-09 1 6.000000000000001e-09 1 6.0100000000000005e-09 1 1e-08 1 1.001e-08 1 1.4e-08 1 1.401e-08 1 1.8000000000000002e-08 1 1.8010000000000004e-08 1 2.2000000000000005e-08 1 2.2010000000000007e-08 1 2.6000000000000008e-08 1 2.601000000000001e-08 1 3.000000000000001e-08 1 3.001000000000001e-08 1 3.4000000000000007e-08 1 3.4010000000000005e-08 1 3.8e-08 1 3.801e-08 1 4.2e-08 1 4.201e-08 1 4.5999999999999995e-08 1 4.600999999999999e-08 1 4.999999999999999e-08 1 5.000999999999999e-08 1 5.399999999999999e-08 1 5.4009999999999985e-08 1 5.7999999999999983e-08 1 5.800999999999998e-08 1 6.199999999999999e-08 1 6.200999999999998e-08 1 6.6e-08 1 6.601e-08 1 7e-08 1 7.001e-08 1 7.400000000000001e-08 1 7.401000000000001e-08 1 7.800000000000002e-08 1 7.801000000000002e-08 1 8.200000000000003e-08 1 8.201000000000003e-08 1 8.600000000000004e-08 1 8.601000000000004e-08 1 9.000000000000005e-08 1 9.001000000000005e-08 1 9.400000000000006e-08 1 9.401000000000006e-08 1 9.800000000000007e-08 1 9.801000000000007e-08 1 1.0200000000000008e-07 1 1.0201000000000008e-07 1 1.0600000000000009e-07 1 1.0601000000000009e-07 1 1.100000000000001e-07 1 1.100100000000001e-07 1 1.1400000000000011e-07 1 1.140100000000001e-07 1 1.1800000000000012e-07 1 1.1801000000000012e-07 1 1.220000000000001e-07 1 1.2201000000000012e-07 1 1.260000000000001e-07 1 1.260100000000001e-07 1 1.3000000000000008e-07 1 1.300100000000001e-07 1 1.3400000000000006e-07 1 1.3401000000000007e-07 1 1.3800000000000004e-07 1 1.3801000000000006e-07 1 1.4200000000000003e-07 1 1.4201000000000004e-07 1 1.46e-07 1 1.4601000000000002e-07 1 1.5e-07 1 1.5001e-07 1 1.5399999999999998e-07 1 1.5401e-07 1 1.5799999999999996e-07 1 1.5800999999999997e-07 1 1.6199999999999994e-07 1 1.6200999999999995e-07 1 1.6599999999999992e-07 1 1.6600999999999994e-07 1 1.699999999999999e-07 1 1.7000999999999992e-07 1 1.739999999999999e-07 1 1.740099999999999e-07 1 1.7799999999999987e-07 1 1.7800999999999988e-07 1 1.8199999999999986e-07 1 1.8200999999999987e-07 1 1.8599999999999984e-07 1 1.8600999999999985e-07 1 1.8999999999999982e-07 1 1.9000999999999983e-07 1 1.939999999999998e-07 1 1.9400999999999982e-07 1 1.979999999999998e-07 1 1.980099999999998e-07 1 2.0199999999999977e-07 1 2.0200999999999978e-07 1 2.0599999999999975e-07 1 2.0600999999999976e-07 1 2.0999999999999974e-07 1 2.1000999999999975e-07 1 2.1399999999999972e-07 1 2.1400999999999973e-07 1 2.179999999999997e-07 1 2.1800999999999971e-07 1 2.2199999999999969e-07 1 2.220099999999997e-07 1 2.2599999999999967e-07 1 2.2600999999999968e-07 1 2.2999999999999965e-07 1 2.3000999999999966e-07 1 2.3399999999999963e-07 1 2.3400999999999964e-07 1 2.3799999999999962e-07 1 2.3800999999999963e-07 1 2.419999999999996e-07 1 2.420099999999996e-07 1 2.459999999999996e-07 1 2.460099999999996e-07 1 2.4999999999999957e-07 1 2.500099999999996e-07 1 2.5399999999999955e-07 1 2.5400999999999956e-07 1 2.5799999999999953e-07 1 2.5800999999999954e-07 1 2.619999999999995e-07 1 2.620099999999995e-07 1 2.659999999999995e-07 1 2.660099999999995e-07 1 2.699999999999995e-07 1 2.700099999999995e-07 1 2.7399999999999946e-07 1 2.740099999999995e-07 1 2.7799999999999945e-07 1 2.7800999999999946e-07 1 2.8199999999999943e-07 1 2.8200999999999944e-07 1 2.859999999999994e-07 1 2.860099999999994e-07 1 2.899999999999994e-07 1 2.900099999999994e-07 1 2.939999999999994e-07 1 2.940099999999994e-07 1 2.9799999999999936e-07 1 2.9800999999999937e-07 1 3.0199999999999934e-07 1 3.0200999999999935e-07 1 3.059999999999993e-07 1 3.0600999999999934e-07 1 3.099999999999993e-07 1 3.100099999999993e-07 1 3.139999999999993e-07 1 3.140099999999993e-07 1 3.179999999999993e-07 1 3.180099999999993e-07 1 3.2199999999999926e-07 1 3.2200999999999927e-07 1 3.2599999999999924e-07 1 3.2600999999999925e-07 1 3.299999999999992e-07 1 3.3000999999999923e-07 1 3.339999999999992e-07 1 3.340099999999992e-07 1 3.379999999999992e-07 1 3.380099999999992e-07 1 3.4199999999999917e-07 1 3.420099999999992e-07 1 3.4599999999999915e-07 1 3.4600999999999917e-07 1 3.4999999999999914e-07 1 3.5000999999999915e-07 1 3.539999999999991e-07 1 3.5400999999999913e-07 1 3.579999999999991e-07 1 3.580099999999991e-07 1 3.619999999999991e-07 1 3.620099999999991e-07 1 3.6599999999999907e-07 1 3.660099999999991e-07 1 3.6999999999999905e-07 1 3.7000999999999906e-07 1 3.7399999999999903e-07 1 3.7400999999999905e-07 1 3.77999999999999e-07 1 3.7800999999999903e-07 1 3.81999999999999e-07 1 3.82009999999999e-07 1 3.85999999999999e-07 1 3.86009999999999e-07 1 3.8999999999999897e-07 1 3.90009999999999e-07 1 3.9399999999999895e-07 1 3.9400999999999896e-07 1 3.9799999999999893e-07 1 3.9800999999999894e-07 1 3.999999999999989e-07 1)
X13 __vinn_v vinn __vinn_s 0 inout_sw_mod
V14 __vinn_v 0 DC 0 PWL(0 0 2e-09 0 2.0100000000000003e-09 0.9229998730890845 6.000000000000001e-09 0.9229998730890845 6.0100000000000005e-09 0.9093397795685655 1e-08 0.9093397795685655 1.001e-08 0.9019919504641908 1.4e-08 0.9019919504641908 1.401e-08 0.8874826768895754 1.8000000000000002e-08 0.8874826768895754 1.8010000000000004e-08 0.9247401723665494 2.2000000000000005e-08 0.9247401723665494 2.2010000000000007e-08 0.9135949281538527 2.6000000000000008e-08 0.9135949281538527 2.601000000000001e-08 0.9058860549785638 3.000000000000001e-08 0.9058860549785638 3.001000000000001e-08 0.884387000125822 3.4000000000000007e-08 0.884387000125822 3.4010000000000005e-08 0.9275131347237916 3.8e-08 0.9275131347237916 3.801e-08 0.9178290246483628 4.2e-08 0.9178290246483628 4.201e-08 0.8938041429720397 4.5999999999999995e-08 0.8938041429720397 4.600999999999999e-08 0.8941055631862024 4.999999999999999e-08 0.8941055631862024 5.000999999999999e-08 0.9232021672425288 5.399999999999999e-08 0.9232021672425288 5.4009999999999985e-08 0.9155348580548928 5.7999999999999983e-08 0.9155348580548928 5.800999999999998e-08 0.9035194919297073 6.199999999999999e-08 0.9035194919297073 6.200999999999998e-08 0.890549934822369 6.6e-08 0.890549934822369 6.601e-08 0.9346344762655736 7e-08 0.9346344762655736 7.001e-08 0.9278156072516204 7.400000000000001e-08 0.9278156072516204 7.401000000000001e-08 0.9196343631607024 7.800000000000002e-08 0.9196343631607024 7.801000000000002e-08 0.8983281760108197 8.200000000000003e-08 0.8983281760108197 8.201000000000003e-08 0.9380295338908798 8.600000000000004e-08 0.9380295338908798 8.601000000000004e-08 0.9315754954486554 9.000000000000005e-08 0.9315754954486554 9.001000000000005e-08 0.9044336748861189 9.400000000000006e-08 0.9044336748861189 9.401000000000006e-08 0.9032282187224409 9.800000000000007e-08 0.9032282187224409 9.801000000000007e-08 0.9401023811107915 1.0200000000000008e-07 0.9401023811107915 1.0201000000000008e-07 0.9225083278674399 1.0600000000000009e-07 0.9225083278674399 1.0601000000000009e-07 0.922338803183268 1.100000000000001e-07 0.922338803183268 1.100100000000001e-07 0.894158200640667 1.1400000000000011e-07 0.894158200640667 1.140100000000001e-07 0.9345831856837759 1.1800000000000012e-07 0.9345831856837759 1.1801000000000012e-07 0.9331848299609109 1.220000000000001e-07 0.9331848299609109 1.2201000000000012e-07 0.9130080706046274 1.260000000000001e-07 0.9130080706046274 1.260100000000001e-07 0.9112244999149784 1.3000000000000008e-07 0.9112244999149784 1.300100000000001e-07 0.9403981266755451 1.3400000000000006e-07 0.9403981266755451 1.3401000000000007e-07 0.9415273223909135 1.3800000000000004e-07 0.9415273223909135 1.3801000000000006e-07 0.9345228163146784 1.4200000000000003e-07 0.9345228163146784 1.4201000000000004e-07 0.9112190374554862 1.46e-07 0.9112190374554862 1.4601000000000002e-07 0.9577795458012943 1.5e-07 0.9577795458012943 1.5001e-07 0.9319255839403128 1.5399999999999998e-07 0.9319255839403128 1.5401e-07 0.9169712589454341 1.5799999999999996e-07 0.9169712589454341 1.5800999999999997e-07 0.910861795375126 1.6199999999999994e-07 0.910861795375126 1.6200999999999995e-07 0.9522793095267338 1.6599999999999992e-07 0.9522793095267338 1.6600999999999994e-07 0.9337000145676675 1.699999999999999e-07 0.9337000145676675 1.7000999999999992e-07 0.9349954757157106 1.739999999999999e-07 0.9349954757157106 1.740099999999999e-07 0.9112202644309502 1.7799999999999987e-07 0.9112202644309502 1.7800999999999988e-07 0.9515126208769997 1.8199999999999986e-07 0.9515126208769997 1.8200999999999987e-07 0.9303502329478276 1.8599999999999984e-07 0.9303502329478276 1.8600999999999985e-07 0.9256414738190369 1.8999999999999982e-07 0.9256414738190369 1.9000999999999983e-07 0.9115567833339494 1.939999999999998e-07 0.9115567833339494 1.9400999999999982e-07 0.9633076118700122 1.979999999999998e-07 0.9633076118700122 1.980099999999998e-07 0.9499759218155756 2.0199999999999977e-07 0.9499759218155756 2.0200999999999978e-07 0.9326739999357746 2.0599999999999975e-07 0.9326739999357746 2.0600999999999976e-07 0.9251352778268335 2.0999999999999974e-07 0.9251352778268335 2.1000999999999975e-07 0.9642648937060199 2.1399999999999972e-07 0.9642648937060199 2.1400999999999973e-07 0.9612817162183684 2.179999999999997e-07 0.9612817162183684 2.1800999999999971e-07 0.9422152273395152 2.2199999999999969e-07 0.9422152273395152 2.220099999999997e-07 0.9236350990008733 2.2599999999999967e-07 0.9236350990008733 2.2600999999999968e-07 0.9718998900726795 2.2999999999999965e-07 0.9718998900726795 2.3000999999999966e-07 0.9442074922651486 2.3399999999999963e-07 0.9442074922651486 2.3400999999999964e-07 0.9428967311243629 2.3799999999999962e-07 0.9428967311243629 2.3800999999999963e-07 0.9244508046628782 2.419999999999996e-07 0.9244508046628782 2.420099999999996e-07 0.9606473915861834 2.459999999999996e-07 0.9606473915861834 2.460099999999996e-07 0.9504447764010691 2.4999999999999957e-07 0.9504447764010691 2.500099999999996e-07 0.9394754821113414 2.5399999999999955e-07 0.9394754821113414 2.5400999999999956e-07 0.9167853462857787 2.5799999999999953e-07 0.9167853462857787 2.5800999999999954e-07 0.9160187887097853 2.619999999999995e-07 0.9160187887097853 2.620099999999995e-07 0.9270425694281946 2.659999999999995e-07 0.9270425694281946 2.660099999999995e-07 0.8992282654685586 2.699999999999995e-07 0.8992282654685586 2.700099999999995e-07 0.9146080248516479 2.7399999999999946e-07 0.9146080248516479 2.740099999999995e-07 0.910881558887985 2.7799999999999945e-07 0.910881558887985 2.7800999999999946e-07 0.9501152379481118 2.8199999999999943e-07 0.9501152379481118 2.8200999999999944e-07 0.9358245209538629 2.859999999999994e-07 0.9358245209538629 2.860099999999994e-07 0.9161665113926325 2.899999999999994e-07 0.9161665113926325 2.900099999999994e-07 0.917734632073306 2.939999999999994e-07 0.917734632073306 2.940099999999994e-07 0.887610434771671 2.9799999999999936e-07 0.887610434771671 2.9800999999999937e-07 0.938349063375366 3.0199999999999934e-07 0.938349063375366 3.0200999999999935e-07 0.9193634292604587 3.059999999999993e-07 0.9193634292604587 3.0600999999999934e-07 0.9596091206420604 3.099999999999993e-07 0.9596091206420604 3.100099999999993e-07 0.9354136139251679 3.139999999999993e-07 0.9354136139251679 3.140099999999993e-07 0.9487196073111339 3.179999999999993e-07 0.9487196073111339 3.180099999999993e-07 0.8912354030974007 3.2199999999999926e-07 0.8912354030974007 3.2200999999999927e-07 0.9386560045225616 3.2599999999999924e-07 0.9386560045225616 3.2600999999999925e-07 0.9456431777611292 3.299999999999992e-07 0.9456431777611292 3.3000999999999923e-07 0.9424086899479269 3.339999999999992e-07 0.9424086899479269 3.340099999999992e-07 0.9251843327600202 3.379999999999992e-07 0.9251843327600202 3.380099999999992e-07 0.911113068344296 3.4199999999999917e-07 0.911113068344296 3.420099999999992e-07 0.9583717867358764 3.4599999999999915e-07 0.9583717867358764 3.4600999999999917e-07 0.920729353682379 3.4999999999999914e-07 0.920729353682379 3.5000999999999915e-07 0.8928307765947835 3.539999999999991e-07 0.8928307765947835 3.5400999999999913e-07 0.883239991763298 3.579999999999991e-07 0.883239991763298 3.580099999999991e-07 0.9242239535506341 3.619999999999991e-07 0.9242239535506341 3.620099999999991e-07 0.9286948079428141 3.6599999999999907e-07 0.9286948079428141 3.660099999999991e-07 0.9220196017224561 3.6999999999999905e-07 0.9220196017224561 3.7000999999999906e-07 0.9019688094276991 3.7399999999999903e-07 0.9019688094276991 3.7400999999999905e-07 0.9285835397762265 3.77999999999999e-07 0.9285835397762265 3.7800999999999903e-07 0.9444930833431022 3.81999999999999e-07 0.9444930833431022 3.82009999999999e-07 0.92246382421756 3.85999999999999e-07 0.92246382421756 3.86009999999999e-07 0.9312314959212802 3.8999999999999897e-07 0.9312314959212802 3.90009999999999e-07 0.9143015743647045 3.9399999999999895e-07 0.9143015743647045 3.9400999999999896e-07 0.9055060423711787 3.9799999999999893e-07 0.9055060423711787 3.9800999999999894e-07 0.9341749482062064 3.999999999999989e-07 0.9341749482062064)
V15 __vinn_s 0 DC 1 PWL(0 1 2e-09 1 2.0100000000000003e-09 1 6.000000000000001e-09 1 6.0100000000000005e-09 1 1e-08 1 1.001e-08 1 1.4e-08 1 1.401e-08 1 1.8000000000000002e-08 1 1.8010000000000004e-08 1 2.2000000000000005e-08 1 2.2010000000000007e-08 1 2.6000000000000008e-08 1 2.601000000000001e-08 1 3.000000000000001e-08 1 3.001000000000001e-08 1 3.4000000000000007e-08 1 3.4010000000000005e-08 1 3.8e-08 1 3.801e-08 1 4.2e-08 1 4.201e-08 1 4.5999999999999995e-08 1 4.600999999999999e-08 1 4.999999999999999e-08 1 5.000999999999999e-08 1 5.399999999999999e-08 1 5.4009999999999985e-08 1 5.7999999999999983e-08 1 5.800999999999998e-08 1 6.199999999999999e-08 1 6.200999999999998e-08 1 6.6e-08 1 6.601e-08 1 7e-08 1 7.001e-08 1 7.400000000000001e-08 1 7.401000000000001e-08 1 7.800000000000002e-08 1 7.801000000000002e-08 1 8.200000000000003e-08 1 8.201000000000003e-08 1 8.600000000000004e-08 1 8.601000000000004e-08 1 9.000000000000005e-08 1 9.001000000000005e-08 1 9.400000000000006e-08 1 9.401000000000006e-08 1 9.800000000000007e-08 1 9.801000000000007e-08 1 1.0200000000000008e-07 1 1.0201000000000008e-07 1 1.0600000000000009e-07 1 1.0601000000000009e-07 1 1.100000000000001e-07 1 1.100100000000001e-07 1 1.1400000000000011e-07 1 1.140100000000001e-07 1 1.1800000000000012e-07 1 1.1801000000000012e-07 1 1.220000000000001e-07 1 1.2201000000000012e-07 1 1.260000000000001e-07 1 1.260100000000001e-07 1 1.3000000000000008e-07 1 1.300100000000001e-07 1 1.3400000000000006e-07 1 1.3401000000000007e-07 1 1.3800000000000004e-07 1 1.3801000000000006e-07 1 1.4200000000000003e-07 1 1.4201000000000004e-07 1 1.46e-07 1 1.4601000000000002e-07 1 1.5e-07 1 1.5001e-07 1 1.5399999999999998e-07 1 1.5401e-07 1 1.5799999999999996e-07 1 1.5800999999999997e-07 1 1.6199999999999994e-07 1 1.6200999999999995e-07 1 1.6599999999999992e-07 1 1.6600999999999994e-07 1 1.699999999999999e-07 1 1.7000999999999992e-07 1 1.739999999999999e-07 1 1.740099999999999e-07 1 1.7799999999999987e-07 1 1.7800999999999988e-07 1 1.8199999999999986e-07 1 1.8200999999999987e-07 1 1.8599999999999984e-07 1 1.8600999999999985e-07 1 1.8999999999999982e-07 1 1.9000999999999983e-07 1 1.939999999999998e-07 1 1.9400999999999982e-07 1 1.979999999999998e-07 1 1.980099999999998e-07 1 2.0199999999999977e-07 1 2.0200999999999978e-07 1 2.0599999999999975e-07 1 2.0600999999999976e-07 1 2.0999999999999974e-07 1 2.1000999999999975e-07 1 2.1399999999999972e-07 1 2.1400999999999973e-07 1 2.179999999999997e-07 1 2.1800999999999971e-07 1 2.2199999999999969e-07 1 2.220099999999997e-07 1 2.2599999999999967e-07 1 2.2600999999999968e-07 1 2.2999999999999965e-07 1 2.3000999999999966e-07 1 2.3399999999999963e-07 1 2.3400999999999964e-07 1 2.3799999999999962e-07 1 2.3800999999999963e-07 1 2.419999999999996e-07 1 2.420099999999996e-07 1 2.459999999999996e-07 1 2.460099999999996e-07 1 2.4999999999999957e-07 1 2.500099999999996e-07 1 2.5399999999999955e-07 1 2.5400999999999956e-07 1 2.5799999999999953e-07 1 2.5800999999999954e-07 1 2.619999999999995e-07 1 2.620099999999995e-07 1 2.659999999999995e-07 1 2.660099999999995e-07 1 2.699999999999995e-07 1 2.700099999999995e-07 1 2.7399999999999946e-07 1 2.740099999999995e-07 1 2.7799999999999945e-07 1 2.7800999999999946e-07 1 2.8199999999999943e-07 1 2.8200999999999944e-07 1 2.859999999999994e-07 1 2.860099999999994e-07 1 2.899999999999994e-07 1 2.900099999999994e-07 1 2.939999999999994e-07 1 2.940099999999994e-07 1 2.9799999999999936e-07 1 2.9800999999999937e-07 1 3.0199999999999934e-07 1 3.0200999999999935e-07 1 3.059999999999993e-07 1 3.0600999999999934e-07 1 3.099999999999993e-07 1 3.100099999999993e-07 1 3.139999999999993e-07 1 3.140099999999993e-07 1 3.179999999999993e-07 1 3.180099999999993e-07 1 3.2199999999999926e-07 1 3.2200999999999927e-07 1 3.2599999999999924e-07 1 3.2600999999999925e-07 1 3.299999999999992e-07 1 3.3000999999999923e-07 1 3.339999999999992e-07 1 3.340099999999992e-07 1 3.379999999999992e-07 1 3.380099999999992e-07 1 3.4199999999999917e-07 1 3.420099999999992e-07 1 3.4599999999999915e-07 1 3.4600999999999917e-07 1 3.4999999999999914e-07 1 3.5000999999999915e-07 1 3.539999999999991e-07 1 3.5400999999999913e-07 1 3.579999999999991e-07 1 3.580099999999991e-07 1 3.619999999999991e-07 1 3.620099999999991e-07 1 3.6599999999999907e-07 1 3.660099999999991e-07 1 3.6999999999999905e-07 1 3.7000999999999906e-07 1 3.7399999999999903e-07 1 3.7400999999999905e-07 1 3.77999999999999e-07 1 3.7800999999999903e-07 1 3.81999999999999e-07 1 3.82009999999999e-07 1 3.85999999999999e-07 1 3.86009999999999e-07 1 3.8999999999999897e-07 1 3.90009999999999e-07 1 3.9399999999999895e-07 1 3.9400999999999896e-07 1 3.9799999999999893e-07 1 3.9800999999999894e-07 1 3.999999999999989e-07 1)
.tran 3.9999999999999893e-10 3.999999999999989e-07
.control
run
set filetype=binary
write
exit
.endc
.probe V(voutp) V(vinn) V(voutn) V(vdd) V(vss) V(vinp) V(v_fz)
.end