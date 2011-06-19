QuestHelper_File["static_zhTW_1.lua"] = "4.1.0.180r"
QuestHelper_Loadtime["static_zhTW_1.lua"] = GetTime()

if GetLocale() ~= "zhTW" then return end
if (UnitFactionGroup("player") == "Alliance" and 1 or 2) ~= 1 then return end

table.insert(QHDB, {
		flightmasters = {
				[2] = "k�Z@�p���8	�",
		[3] = "�7JA\"gVE[�D^A<",
		[4] = "|�@�\
f�_<",
		[5] = " U}���",
		[6] = "~�!����I�	�",
		[7] = "*�DZ5�_8D:��\000��",
		[8] = "�ƍ�(��[�l�0\000��",
		[11] = "�\"`� yh�",
		[12] = "(���uD�WB�B6f���",
		[13] = "�0�W��",
		[14] = "���C��[��	�",
		[15] = "&L\000�",
		[16] = "$�	�Hr�(��t�\"��",
		[17] = "=T\rU8)�D�8�D'�",
		[18] = ")�f6��)�$�P�",
		[20] = "(����>�	m�\000��",
		[22] = "Q�2�J�n���ES0]5��",
		[23] = "��&�ʪ��xfTp-|�",
		[24] = "�vv���~A��EE!<",
		[27] = "���C�#���O",
		[28] = "����3�9F��Y8'�",
		[29] = "@U�rO������b!<",
		[31] = "%���Ȕ���wRƄ�/��",
		[32] = "�����#��c\r��9&�",
		[33] = "��η��.)|�9UZ�O�,�x",
		[34] = "\rѭ���]+�ʸ��� �*\000O",
		[35] = "7�B(Fd9,Rr�	�",
		[36] = "4�ą\
k}^��O",
		[37] = "a�*��Zr�	�",
		[38] = "Au�{�&=��U	�",
		[39] = "�������.�e�	�",
		[40] = "<c�\r���lg��\"�V�XжBx",
		[41] = "%Ȅ��h�{=��",
		[42] = "=k�HQ0Y�<�	�",
		[43] = "m�\\�N�f��ݧ�t��I0�",
		[44] = "3��	z^�3	�",
		[45] = "iA&e A�>���Ϣ>�",
		[46] = "iA&e\"gVdX����'�",
		[47] = "A�\r]uD�'�ܫ@'�",
		[48] = "�L�}\\�FGq\
�crY�",
		[49] = "uNC��Т�����\000��",
		[50] = "LfvS�)O��	�",
		[51] = "N�'��g܃	�",
		[52] = "�J�6 C�F���'�",
		[53] = "s���E�CF��Y8'�",
		[54] = "Hy�7��5!�J\000!<",
		[56] = "=hyv�� O",
		[57] = "\\�GB���'�ܫ@'�",
		[58] = "3t��6��R�ˠbq�'�",
		[59] = ";	�K�kB5�\000!<",
		[60] = "l/���8-g\"%	�",
		[61] = "%���4$9F��Y8'�",
		[63] = "�O�jCb��YI{��z�",
		[65] = "Vձ�9�E��tDnA��",
		[67] = "�\
mĶ�c���\000!<",
		[68] = "5O�K�i(��O",
		[69] = "m�}���9��O",
		[70] = "�	��p�b�C	�",
		[71] = "��Bf�b�~\
�ܫ@'�",
		[72] = "(G<�$V�c�JMa<",
		[73] = "��v��4��B�d���p�",
		[74] = "O�!ԃ�1ѡ+K�'�",
		[75] = "��xyAK���	�",
		[76] = "����#�7�O",
		[77] = "�m�����Bx",
		[78] = "tӊ��x*p�@	�",
		[80] = "8��|�Z�Yf�	�",
		[81] = "�z�2!��W],Qa\000��",
		[82] = "����\\��)�^A<",
		[83] = "t�\"j��j4БD�<",
		[84] = "$��ͥ�)��9U�����",
		[86] = "D��cmH��O",
		[87] = "���#ҐK����PT\000�",
		[90] = "}���D�>��bE��",
		[91] = ";�\r���r�*�	�",
		[92] = "�2j[�\000�`��2\000'�",
		[93] = "(3Ek�t,��`�\000!<",
		[95] = "i��	�^�W�O",
		[96] = "�ˍ�Fd7i�*|L'�",
		[97] = "\rG�:()s�ѹ\000!<",
		[99] = "A�I:�&=��U	�",
		[100] = "�R�;�V�=#�K��/���",
		[102] = "�1z�DD��4L&*��",
		[103] = "*�,4W#A��A<",
		[104] = ">���/	@aJ�Fݍ�@�",
		[106] = "�2ju�4$EJ���'�l��",
		[107] = "��e�*�H��O",
		[108] = "L�JО",
		[109] = "w�PY`u��K�0\000��",
		[110] = "��$.�g>�ݑ	TT��bd�O",
		[111] = "��Q��2#@'�",
		[112] = "�5�:���`3-A<",
		[113] = "-�|v��>��{���\000�",
		[114] = "��B.���R^�\"^�<",
		[115] = "�Ӿ8%*UmU�=d'�",
		[116] = "Vհ@�dX����'�",
		[117] = "8v�v���c��<",
		[118] = "PNe6�k`;@[<",
		[119] = ":˭p�P�",
		[121] = "xP���0Y�<�	�",
		[123] = "������%1\
K�$K�'�",
		[124] = "Ѡ�Q)�r�*�	�",
		[125] = "��]uE<��Ba<",
		[127] = "9�(�j�Vy��A<",
		[129] = "U1� F��<��σF�\000��",
		__dictionary = " \",235:K�����������������������������������������������������������������������",
		__prefix = "name=\"",
		__tokens = ":!IkOK! 2ǧ���+`p�5�ZE$�5',�L%\"y#�^�'�{0Ir\\bmL:egm�QSIMeHAgl�bs6m�MC�IeL1K#�)�t0�F�\\�@�$eJI��L�+6J&eF?���F#�J%��\r��J@��\\�M2��SL	�<�)&X��I8�eB����E���T�KbPx�76��m%%� ��(�I-	/C!q.�#�B�H��7\
�\"Z� &^�2SJL�����x�%���Q�,�vE��E�1 @��.;�-��4n�2���)�?	�E&T��\
2�ړ�C�6�.1\"���J��譠�®���\
2���Pr`E�*2�A���ZɵȄ�br�@5��kĸPdNz�N/0�<�!\000�����,6.�WZ:Y@c|\000�&Đp�RK��P�,�8�BK��al}���MP�F��H��/H2����WS^�\000D�\"��C0���`��U�7� �PM�\000M��l��p*C���^1�r��#	��1�#2=^j]��EB�	�\\�(	��T)�°��1Uq� �f-A$<�Gԏ Q�92Р�;xD�@�eC��;\"���ĥ4f��`4l`�r$�G!W7�Fm��٪�&�!��Bx�h06ԁ$˂н�y��1K\000G0e�m\"���>��y��U�$CxPM��A:(�b��-r�<��7��aC(��咂�_�s&/�$�y7�.��qfx|5~E1x��EB�������&��Q�`��@�Y�oȍ��!�:�qq��Ia\
�K�B2�Z(I#�PI\r�˩�o�x2�$��7\
ߛ�#+\000�A�Me�GA!r\
���sA��$-���i��GjD�!X\000B;�e��,�H�JƩ�NnE��@�M� %)^fa� ��KC��)��R0\
�Yʟ�Ǆ\"�\000\r�ᕣy� @�� 0�@��a@��s^���JCS��M]�	�tgN���+�B���L\\�فq���.Vxn\r���P;��\\��Lm1����A��p��\000A~D=�����;�~`h�e�H%-c�\000}������zu����Z����i���e�~B:�x�����\\�e��E\000�nxA�D9������F�!��	r�*\000��.4�44��*�ݛ�(�(.��(���>z��$�p�A�/�q�� �\
�[:��>²kaM����#��jm-�\000�\000��`=���C�C�e(|2��Ȁ�z�<��L�\000��	�ě�.\000N�6���� `�)��� ʓW[9kG���~@�E����65��3�����X1�-4%ʴ\"�`KAq^9�2HPV��F��������0&%���*F�X����UҸb\
�0�ʊ|)b�GX�N<��D%:&�W��}����b�D���g��!�Ms5��]Pv��pj��%����2�Y�\000f������P17�P��&�S@=	.��\000�����u�`fr%�\000\"�G�Yr�U\
D\000�w&Q�eE�(,�j�PI�Fo���T�}�LԞc��Y�N\
`4���J�\r���\rO��5@�!�XK'�J�+E)˵�l��E�b��P��!d+g�׃j�ё�@XG��k8MP%o�0�\000Z�;�e����}XߐfS.��pW#R���R�lZ��\000���f��D�SF��VY\000!)��R�\000X��#�9B���`��H,��%�K\000���i9!x��+�3�@Z�`u���H�jYHK��2��o�J	�B�x@�H\000��!�k�\\� G�aYK��xjФ�J�E�<+��qJB��q	��%Ƥ�y���(X\000�����i��t�Dx5��@���n�A�j5\000 ���[���\000j@��\"< Ir�/�!���~XxeP���Ç�((�b>\000�U%xA_\000$�#��Z�|���\000.����u�k�PS�_�����ƴ�^�0o����~�<�����{ՠS w_l�K��PL����z3���^��!2сd�	\\������\rp�`>>�S\\x<�49Ơ\000#�Ҝ9�2����\000|�� ��N�W��v�vC ��;M��=���GBN���pa���I~�����	P�Ap#ߥR��Q��!�&Ҭ4�e���>YP#��l��\
��o��7��`N@_�����k�f��\000dr@G�&&pF��;Ӆ���-��q�9\000旜�|r\000��t��\000�F�C�	U�\000��l\000A-x��d�f��RG	T��ѹr��s��`��Y��t%0��(b��Ǌ��nS9�!W�%!��LoE�H�p]PK�����p��e�Z���u�dg�E>�ɰ4�F�R�J��m$�H�C�����8.��2�\\tdh?�@���bw�c�	��&�g�w�ٸ;��Л�A��4�ZpMZpH�:t�Pj������Z\000�6����kC�\\Ó;`etOE(\"\000��B�P\0000e�$�&�S��k@D�>e�Ki�\000��.Z0=` \\BYU�\":u	� ���*�rJ��R�Ih�\
9����!�)�D+�5?@7(�C�\000�@(��A��Rd(�#�0K�gg��xV�;+��m����?BçhK\000L�P??@9(�\000*@:'�M+�E�\\�@7��P�\000\000Ԕ����B\000�K�K{�dP:�@?M�#0e��`�|	PP"
	}
}
)
