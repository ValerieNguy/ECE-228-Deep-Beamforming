# ECE 228 Beamforming using Machine Learning for Wireless Communication 

## Code Package Content 

### Baseline Paper Reproduction
Below two figures show deep learning model performing better than baseline with increaing dataset size and in mobility scenario. To reproduce the them, we have used MATLAB(for dataset generation and plotting) + python (for deep learning) for the 4 basestation case. 

![Result_BF](https://github.com/user-attachments/assets/8ffc27e2-5508-415f-a19e-c6c4483f2c36)
![Screenshot 2025-05-31 153313](https://github.com/user-attachments/assets/9a793acf-d6e8-4e57-a3f3-7a31c42b1798)

**Follow the below steps to reproduce these results:**
1. Download DeepMIMOv2 dataset generation files from https://www.deepmimo.net/versions/v2-matlab/
   and the source data of the 'O1_60' scenario from https://www.deepmimo.net/scenarios/o1-scenario/.
2. Run the Generate_DL_data.m in MATLAB to produce the dataset. Do not clear the workspace as few variables will be reused for figure plotting. Dataset will be stored in DLCB_dataset_matlab folder.
3. Run the DL_beamforming.ipynb for deep learning model. This should produce 15 files named DL_Result%.mat. Store these in your local MATLAB folder.
4. Run the Generate_Figure_dataset_mobility.m to plot the two figures.

Credit goes to the paper's code that provided us with the means to setup and run a reproduction of their work, located in this [repository](https://github.com/wireless-intelligence-lab/DeepLearning-CoordinatedBeamforming).

### Model Improvements for Limited Data Scenarios
The original model performs significantly worse when evaluated with 2 base stations and 50 user rows. The notebook, ImprovedBaseline.ipynb, contains an enhanced version of the baseline model from the original paper to get improved results on this scenario. The notebook produces the below results:
![newModel2Base](https://github.com/user-attachments/assets/85d152f7-8f24-49ab-aa0c-c73c3062c6de)
This figure is based on the Python version of the [DeepMIMO dataset](https://deepmimo.net/versions/v2-python/). This is designed for deep learning applications in mmWave and massive MIMO systems. Specifically, it uses the ['O1_60'](https://deepmimo.net/scenarios/o1-scenario/) scenario.

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
