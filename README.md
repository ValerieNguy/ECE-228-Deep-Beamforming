# ECE 228 Beamforming using Machine Learning for Wireless Communication 

## Code Package Content 

### Baseline Paper Reproduction
The script, Coordinated_Beamforming.py generates the following result:
![Result_BF](https://github.com/user-attachments/assets/8ffc27e2-5508-415f-a19e-c6c4483f2c36)
This figure is based on the Python version of the [DeepMIMO dataset](https://deepmimo.net/versions/v2-python/). This is designed for deep learning applications in mmWave and massive MIMO systems. Specifically, it uses the ['O1_60'](https://deepmimo.net/scenarios/o1-scenario/) scenario.

**Follow the below steps to reproduce these results:**
1. Install the DeepMIMO dataset package: `pip install DeepMIMO`
2. Download and extract the '01_60' scenario from the [official DeepMIMO website](https://deepmimo.net/scenarios/o1-scenario/).
3. Open the Python script, Coordinated_Beamforming.py and set the path to your extracted dataset by editing line 48: `parameters['dataset_folder'] = r'C:\Path\To\Your\scenarios'`
4. Run the scipt using Python 3.7+ and TensorFlow 2+: `python Coordinated_Beamforming.py`

### Model Improvements for Limited Data Scenarios
The original model performs significantly worse when evaluated with 2 base stations and 50 user rows. The notebook, ImprovedBaseline.ipynb, contains an enhanced version of the baseline model from the original paper to get improved results on this scenario. The notebook produces the below results:
![newModel2Base](https://github.com/user-attachments/assets/85d152f7-8f24-49ab-aa0c-c73c3062c6de)
This implementations builds on the same dataset and setup as the original script, but is organized for easier experimentation in the form of a Jupyter Notebook.

**Follow the below steps to reproduce these results:**
1. Install DeepMIMO: `pip install DeepMIMO`
2. Download and extract the '01_60' scenario from [official DeepMIMO website](https://deepmimo.net/scenarios/o1-scenario/).
3. Edit cell 4 of the notebook to set the path to you extracted dataset: `parameters['dataset_folder'] = r'C:\Path\To\Your\scenarios'`
4. Launch Jupyter and run the notebook cell by cell using Python 3.7+ and TensorFlow 2+



### Improvements Using Sionna RT 
Although our attempts using Sionna RT were inconclusive, to reproduce our results below, use SionnaSimulation.ipynb. 
![SionnaResults](https://github.com/user-attachments/assets/c4542123-24ff-4838-8fdb-08e2f1078e02)

**Follow the below steps to reproduce these results:**
1. Install Sionna: `pip install sionna`
2. Launch Jupyter and run the notebook cell by cell using Python 3.7+ and TensorFlow 2+

# Referencing
> A. Alkhateeb, S. Alex, P. Varkey, Y. Li, Q. Qu and D. Tujkovic, "[Deep Learning Coordinated Beamforming for Highly-Mobile Millimeter Wave Systems](https://ieeexplore.ieee.org/abstract/document/8395149)," in IEEE Access, vol. 6, pp. 37328-37348, 2018.
