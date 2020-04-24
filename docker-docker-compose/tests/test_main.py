
import unittest
import os
import fake_me_some.fake_me_some as fake_me_some
from config_parent import Config


__author__ = "Hung Nguyen"
__copyright__ = "Hung Nguyen"
__license__ = "mit"

def clean_working_dir(folder: str):
    import os, shutil
     
    for the_file in os.listdir(folder):
        file_path = os.path.join(folder, the_file)
        try:
            if os.path.isfile(file_path):
                os.unlink(file_path)
            #elif os.path.isdir(file_path): shutil.rmtree(file_path)
        except Exception as e:
            print(e)
class Test_main(unittest.TestCase,Config):
    def test_01(self): #using environment variables
        print("Test 1 Ran")
		pass
        
if __name__ == '__main__':
    unittest.main()