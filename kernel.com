�Ȏش ����� ��� ��À�t/��t%��Ht/��Mt*��Pt ��Kt �#���t��������
� ��Q� ��j �W�e �>jt�J�+ô� �c��o��m��m��a��n��d�� �� �$��C��:#u� ��u��n��k��n��o��w��n�À># t~�i �| �>ito� �>ite� �>it[�� �>itQ�� �>itG�!�>it=�<�>it3�h�>it)��>it��>it���>it�:&it�$��# À>#u#�$�?auC�?buC�?ouC�?uu	C�?tu�lÀ>#u#�$�?auC�?suC�?cuC�?iu	C�?iu�oÀ>#u�$�?huC�?euC�?lu	C�?pu��À>#u#�$�?cuC�?luC�?euC�?au	C�?ru��À>#u)�$�?ru!C�?euC�?buC�?ouC�?ou	C�?tu�À>#u�$�?buC�?euC�?eu	C�?pu�û$�?wu-C�?ru'C�?iu!C�?tuC�?euC�?fuC�?lu	C�?pu� û$�?ru'C�?eu!C�?auC�?duC�?fuC�?lu	C�?pu�� û$�?cu!C�?huC�?ruC�?ouC�?nu	C�?ou�û$�?fuC�?iuC�?bu	C�? u�6û$�?duC�?ruC�?au	C�?wu���I�>wt]�>xtV�>ytO�>ztH�>{tA���$+sy�s�&6$�#�$F9$u��u�.p�q�r�6o�&��i����>wtQ�>xtJ�>ytC�>zt<�>{t5�5��u�.p�q�r�6o�&��  ��޻  �� �FA;su��i��i���3�� � �&��  ��޻  �� �FA��du���i�l0�m0�n0� �� �)�n�>n:t��n0�m�>m:t�	�m0�lô�l��m��n��=���
t����� ������ ���"�6"�� t���� ����u���i�N�� ����o	���i�j� ����i���i���C���B�a�a� � �����a$��a��i� � ����������u��>u�����i�$C�? u��
�  � C�&���0 �C�?:u��>u�1��h�>u�1�� ��1��P�1�x� �s�1�n� �i�� ����66 �6!�6�� �C�6 �6�6!�6 :u���i��Ӊ����   P��1��t&��t��Ht!��Mt��Pt��Kt��� �
�& �� � ���&�$� ӈ�$���k���>$ t
�$�����k �$  �f���>k t�û$C�? u��
�w �x �y �z �{ �  �o C�&���0 �C�?,u�o�>o�� �  �p C�&���0 �C�?,u�p�>pO�� �  �q C�&���0 �C�?,u�q�>q�� �  �r C�&���0 �C�?|u�r�>r�� �  �s  C�&� ���0�C�?:u��s�>sp{� �w�� ��� �� � �|��v�x�� ��� �� �# ����X�y�� ��� �� �$ ����:�z�� ��� �� � �����{�� ��� �� �" ���ú  �s� ��u�� t�uô� �ô�û$�#� ӈ�#���#À># t�#�Ɉ#� � ô� ��ʀ��t��βO�� �ô
� � � �ô�C��M��D��=��"�� ��$�># t��C��:#u�"��# ô�$��>�ô����O� � �ô�
���ô �ô�� �  ���
��� ��6�&�� ��6�&�� ��6�&�� ��6�&��0����0����0����0����  OS v0.00000001 created by Ion Dodon FAF-172about - about this OS
help - lists all the available commands
clear - clears the screen
reboot - reboots the system
ascii - shows the ascii table
beep - makes a beep sound

writeflp head,track,sector,drive|size: - writes text data on floppy disk
readflp head,track,sector,drive|size: - reads text data from floppy disk
head={1,2}, track[0-79], sector=[1-18], drive={0,1}, size<=6000

chrono - counts seconds
fib n: - showh first n fibonacci numbers
draw - animated UTM (press enter to stop it)                   head should be 0 or 1track should be in the range [0-79]sector should be in the range [1-18]drive should be 0 or 1size should be than 6000, or equal
                                                                                                                                                                                                                                                                                     