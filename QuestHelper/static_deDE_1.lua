QuestHelper_File["static_deDE_1.lua"] = "4.0.6.161r"
QuestHelper_Loadtime["static_deDE_1.lua"] = GetTime()

if GetLocale() ~= "deDE" then return end
if (UnitFactionGroup("player") == "Alliance" and 1 or 2) ~= 1 then return end

table.insert(QHDB, {
		flightmasters = {
		"���<n��;G����", "����Hrn�`�", "0X�bFd���8o�\000", "4��!��d�ݝA�\000", "\r�����|", "��Šr����4@�", "�FG��ȡ��=��L\000", "\
#0�C������d\000",
		[11] = "��7�ǟ�H��",
		[12] = "@�K(�a�Z���m���",
		[13] = "���ʙ���",
		[14] = ".��8�Ii�>",
		[15] = "�j�p�",
		[16] = "i��v`��r�\000 �",
		[17] = "0.�/a�d�xg4\000",
		[18] = "�pI��Yi��Wo%݃�",
		[19] = "�iT�o�Ԗ��\000",
		[20] = "@�KX��/)@\000��tY0|",
		[21] = "��Xm{g�",
		[22] = "0-N�4#�ZK�\000",
		[23] = "VMD�0/��>",
		[24] = "��F���u:�/z���",
		[25] = "*��_h�",
		[26] = ".#���H,��8o�\000",
		[27] = "\r*�)�I>~?Y\000�",
		[28] = "�3���$`r�\000 �",
		[29] = "�h���Z���@�",
		[30] = "xv>tL�p�������",
		[31] = "�3�Z�V+2����Π��",
		[32] = "��	&��@�*e�����2bOĀ|",
		[33] = "��V�yJ�`���\000",
		[34] = "1��#Š�^j)du���0|",
		[35] = "	��j,��l2tz��",
		[36] = "���^�A�",
		[37] = "\r��o(��Z���",
		[38] = "�ڨ7�\000��K��",
		[39] = "�F���I$`r�\000 �",
		[40] = "	�������o�I���\000A�",
		[41] = "���q~;��<\000��",
		[42] = "���X��� >",
		[43] = "�Q�E1�-*8�-�\000��",
		[44] = "r��r9-P>",
		[45] = "RCi��\\�!V��\000",
		[46] = "Ra-��O��m&�\000",
		[47] = "�ƥ.��x>",
		[48] = "���$\0003G�{��",
		[49] = "��,��䭲�~ �",
		[50] = "P�0���X~\000�",
		[51] = "�ē]�M�L����j�|",
		[52] = "�>?��^l�vL\000",
		[53] = "%:�!h��>",
		[54] = "貀��xS0�m\000�",
		[55] = "OI+z�X5��ݽ��",
		[56] = "Eb�R��x���\000 �",
		[57] = "6�e�pi����'��",
		[58] = "	�'�@y��!��&���",
		[59] = "�AT0S�fP�",
		[60] = "�p7�\"���W�\000",
		[61] = "�0$C%$`r�\000 �",
		[63] = "���O���e�9�V���",
		[64] = "\
V�iW��DRsg�",
		[65] = "�ZP���Z���j�|",
		[67] = "8���9a#�0 m�\000",
		[68] = "���E����",
		[69] = "�>�Xrn�`�",
		[70] = "u� ��`�O�tz��",
		[71] = "�Âj�O�Ni<\000",
		[72] = "H�K�P5��c�＊\000|",
		[73] = "�Z��d���@�",
		[74] = "\
V\\e ��qg��r�`\000",
		[75] = "�{\000_���\000 �",
		[76] = "��b�Y�B_�>",
		[77] = "��&����)\000 �",
		[78] = "�����t鎘>",
		[79] = "PV�!�Z:,�>",
		[80] = "	tF�V��",
		[81] = "u�/��z��!�`�",
		[82] = "\
��1��G�X~\000�",
		[83] = "\rp�R�8ZK,���",
		[84] = "\
q=��&ݍtX��,�֙#\r�=E�����",
		[86] = "� ��#mW.>",
		[87] = "c�`)|y*�#�L\000",
		[88] = "4�2�1�{�J�E\000\000",
		[89] = "�v�(��<֢�]h�\000",
		[90] = "�e�\000��01*y�F`End�>",
		[91] = "���\
�{[�>",
		[92] = "-^�3ӏl�'��\\*�\000A�",
		[93] = "\
S�ŠT����C\000 �",
		[94] = "�͚V����9P=��\000",
		[95] = "\r�\
�2�sf�=��",
		[96] = "\rK��SgWSql \000",
		[97] = "�c%��\";�`�\000",
		[98] = "��IEU�|ܬ��",
		[99] = "��\"$\
`�U��w`�",
		[100] = "C��8'K��km�UB�M\000>",
		[102] = "l	Ѥ����Gy.�\000",
		[103] = "j�ĕ,l^YS7_\000�",
		[104] = "\
����R`lX ��",
		[105] = "��|��e��",
		[106] = "`���aq[���oh�\000|",
		[107] = "��aI�4�B\000 �",
		[108] = "C�=��",
		[109] = "�!���6���*\000 �",
		[110] = "���$	��;M �a�\000>",
		[111] = "\000�<�C�8iS����",
		[112] = "�R�Gs��'�,��\000",
		[113] = "+.:�&d���jBa�|",
		[114] = "	�-A��sf�=��",
		[115] = "�X����^�{E�\000��",
		[116] = "\
���0w9l󼪅��\000|",
		[117] = "	Wа��D����",
		[118] = "��|��Ii�>",
		[119] = "	7�Ȑ|",
		[120] = "��_%}��",
		[121] = "�^٫��t	k|y����|",
		[122] = "	3(���K\000�",
		[123] = "U`.��*�j9�V���",
		[124] = "ΰU�\"6�>",
		[125] = "�����nK.>",
		[127] = "�Z!'8�d���05���",
		[128] = "�u� B�nG%��",
		[129] = "`��8�\000 �",
		__dictionary = " \"',235:=ABCDEFGHKLMNOPRSTUVWZabcdefghijklmnopqrstuvwxyz������",
		__tokens = "Y�H�>12 @��\
$i�͟((����cQ^���s�\000_�dVU{��J��}�=ѤE\
d1�Hx� tȒ1��04��08����L�m^x�Fq��00��d`��0@x�0d�Ν�ɚ�$���n*2z��g\
Cp�_@$�~0h�O@`���0p�G\000c�WS�;-�S�1?s�`�0R�ץv�	�� ���\
���[���8��Pc���A(��f*����у�R&�}�Q��]��	HK �@4#�@Z�K\
@@µ*0/Ăah��F+�&Eu�%s�+\"�H`�\
�%k\rh\000+\000g�IX</��Ţ��X�!2��f�ƽ'7�418^�U��\000��e�\000qc\000�Sc�_�䢰�N'Wª�:�)\000��H�P��h�N���wbIXS��I��&����C�.�/��ilɐ[������de��w�\000m��\000i;L�K���l��@c�V�\000�k�Vdq����Z�8bM��)� �$(n��_�$$�AZ	Y8�� �+nA�t�u��X��\"��!}�(�\\X*\\^�8=��>p�x�CX�\000�C+�}h���Vi\"��AKNu +�آ	X�u�)@Wpyzp��m���!q\000ќ]���p\"㝋n���gG�4\"�� N\\�f%�W�°V[��:���\
rZX��a~P@���Wՠ���	de��z�^�8\
pg`���~M��T/��h��+BC��Pb��g�p0('n4\
�UN�\000\000$7_�']Er�P7d�i�-�<�7蘁�nv �[����x��U@�aU��)�i�*Km����n���	��x1yA��d��@f���*��%Ġ}�K�̈́;H��NA��z��f���`�J�@�xY��L\000�\000�Ks��a_��8GI_�w�>���V\"\000��zA\000+	U,�sG���P��s�lNT��@L0�R4!p��&��KY��B�\\S�ōE`ѐx���JCb@X/���eF�\000R\\�{9�Ҹ#p]xw��QS\"��ʸ�}���f�I�\\b�}��_^��<�@�&�Į��PA�����>|����ju#6$0;`���`���<\\(}aߙS���\\�� L\r��V���5�y��`)�\000��TP�RЮW���X&�N��>@���c�h�U+����(=��~��4\000Y��Z�<Ӭ��H���TRe����|���	U�/�_�pSL�Z>�<v�t��C �M*��\000�SҝNť��Lg� 	= <_���큘V)c �	�N|Ϩ*)��	�����5�\0002ǀDd!YO�1*'�`�Ak�7% �9�q�YF�)r��*-J�+�s4��I_���\000��YK�dE��>z�:#�IF�(���	qy`��qH%�w�Y�AG\000��0 �±%�FᏁ,R��<N��Ҭ�C(~R��z>��̛��'IО|nN��H̴���x��.=�72�7�JAFi�&,Y0�|=	�bs�2).Iد\
�:O�pz�e0���OK�ylY��`�\
�%]���Dt��J3*	��>\000������.;AT�M���P`�Oq�n�}:�&\000�H�L̰�pnΘ�`��;���A��d��S��+��G���S*�{�����fJ̚p��2@�f�����S�q�p�\000�Gf}�H�2e�&�'�U���B�^I��\000$f��B�Jԅ`l|�7>�@����82��2�A+��nq0�` �]fK0�t�L(Vj�:�c̐\
zY;�(��k|^c���r��K�2N�ԯ��@Sa��	��lH�	��0����F���P$�J���5�����=}�?��}2�p}��ݚ`���lGn�NX�\\�u\000�Dę8��H�p�`8�݈��\000�����R+=ת�!��˼[\"\
#���X�mRXǳx�'�P&�NB&|�Ђ����Pi,$��P�$i����'G��lr��|'8V�GjA\"�/J�dX&���\000I�����܃d�\
�(�%����x,�f&9���񓟅g�Qc�%�:�18�b�OH�z��,�Xh)N�n��0\
^m�O@�M\
,_R��h� R���VOo�jˁ\\����+Az�ݵ`�L�$��e����I�J>-�O��i�3���~%Q����x̛��\
Z(&Q�y��-������c��{��j�)������xrN�8�`����?����2�}O��䯁���[pw݌��a��K-������\"�\
ϼ�z�����	_C���A��zu֪��,\000�>um��^0�J��8!ͷ��\000`İV<�]?\\�i_�qO�TAt[p:9�F`�iBAi����	҃E&�=�\000C�S����b����?���}A�q��r�OpA�T����O\
�b��\"K¸$�<�P_������S�B��\000\
��#8��X�F���f��1�.�᭣����J\
�\\+�\
�$�_(��TW�1��.͘��\000��,\
Q���<W�H�t��a��\
�$�Z�\000@E�Ь�`X	��n\000�W�$Y��:�L����\000+�����C���d�@��@�d�|d�%9UE�4\r���m�G�.H}@|/ϴ\\�#�XÜ�}\000\\C��u��@@\000�X\rD<\000�,`��@h������Lŭ���|@A$J4���L��\000Q=-<�5D<؍\000}@�\r\000��lD=�����E�\000�\000	\000�@	�\000�<�L	�<\
�m�����Q\r%���������<,��i�	���\r��n	l��@ԀO5��-\0005��m��\000����������B�b\
5��������8���\000DId���B�}�ߎ>\000|>\000�>\000�>�\000@�"
	}
}
)