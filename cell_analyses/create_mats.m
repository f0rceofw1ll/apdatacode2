%% Creating mat files from experimental data
% 2/20/13
% setup:
% folder names are experiment_[XXXXXX A/PM]
% Inside each folder there can be 
% 1. clog_test.lvm [1 x N]
% 2. neuron_hunting.lvm [1 x N]
% 3. gigaseal_traces.lvm [2 x N]
% 4. recording.lvm [2 x N]


%% Directories:
% expDirectory should be where all the experiment... folders are
% folderName is the experiment_XXXX PM_PC folder
clear all

folderLocation = '..\Out';
expFolderName = '2013-04-24 in vivo';
folder_prefix = 'experiment';

expDirectory = [folderLocation '\' expFolderName '\'];

reZeroCombinedDepth;
reZeroCombinedRMP;
rezeroPipetteR;

depthList =  struct('FolderName', {}, 'depths', []);
rmpList = struct('FolderName', {}, 'rmp', []);
pipetteRList = struct('FolderName', {}, 'R', []);

%Depth List will be structued like this:
%depthList.folderName = [N x 1] array of expFolderNames (e.g.
%'2013-03-18 in vivo')
% depthList.depths [N x 1] array of electrode depths

%%
% List of all trials
expList = dir([expDirectory '\' folder_prefix '*']);

recordingsIn = {}; % cell of strings of files that contain recordings

for i = 1:length(expList)
    fileName = [expDirectory 'mat_' expList(i).name];
    folderName = [expDirectory expList(i).name];
    disp(['FOLDER: ' folderName])
    [ct nh gt wc d t res outID Vh Rs Ih id hasRec] = load_experiment_data(expDirectory, expList, i);
    
    rec.clog_test = ct;
    rec.neuron_hunting = nh;
    rec.gigaseal_traces = gt;
    rec.wholeCell = wc;
    rec.date = d;
    rec.time = t;
    rec.result = res;
    rec.outputID = outID;
    
    rec.Rseries = Rs;
    rec.Iholding = Ih;
    rec.initial_depth = id;
    
    if hasRec
        recordingsIn{end+1} = folderName;
        
        % get depth of recording
        newdL = struct('FolderName', folderName, 'depths', getDepth(rec));
        depthList = [depthList;newdL];
        
        % get RMP
        rec.Vholding = getVholding(folderName); % use 1st second of recording to find RMP
        newRMP = struct('FolderName', folderName, 'rmp', rec.Vholding);
        rmpList = [rmpList;newRMP];
        
        % Get pipette R
        newR = struct('FolderName', folderName, 'R', getPipetteR(rec));
        pipetteRList = [pipetteRList; newR];
        
    end
    
    save(fileName, 'rec');
end

recordingsIn = recordingsIn'; % easy viewing
save([expDirectory '\recordingsIn'], 'recordingsIn') % list of files that have recordings

updateCombinedDepth(depthList);
updateCombinedRMP(rmpList);
updatePipetteR(pipetteRList);

