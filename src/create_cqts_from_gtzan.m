function create_cqts_from_gtzan(training_percentage, folders)
% This function create the spectograms for the songs in the dataset
% at the same time it splits those spectograms into training and testing
% (storing in in different subdirectories) the amount of songs used for
% training is controlled by the paramter training_percentage

num_songs = 100; % number of songs to process per each genre

% create directories if they don't exists
savePathroot = './data/cqts/';
savePathTraining = './data/cqts/training/';
savePathTesting = './data/cqts/testing/';

util_create_directory_structure(savePathroot);

num_genres = size(folders,1);

for i=1:num_genres;
    dat_training = [];
    dat_testing = [];
    folderName = char(folders(i));
    
    % get the testing and and training indexings
    training_idxs = randperm(num_songs,training_percentage)-1;
    testing_idxs = setdiff(0:num_songs-1,training_idxs);
    
    fprintf('Creating constant q transforms of genre %s for training set\n',folderName);
    for j=training_idxs
        path = strcat('data/genres/',folderName ,'/',folderName ,'.',sprintf('%05d',j), '.au');        
        P = get_cqt_from_audio(path);
        dat_training = horzcat(dat_training, P);
    end
    
    fprintf('Creating constant q transforms of genre %s for testing set\n',folderName);
    for j=testing_idxs
        path = strcat('data/genres/',folderName ,'/',folderName ,'.',sprintf('%05d',j), '.au');
        P = get_cqt_from_audio(path);
        dat_testing = horzcat(dat_testing, P);
    end
    
    fprintf('saving constant q transforms to file...\n');
    %write genre data to file
    filename_tr = strcat(savePathTraining,folderName ,'_data');
    filename_te = strcat(savePathTesting,folderName ,'_data');

    save(filename_tr, 'dat_training');
    save(filename_te, 'dat_testing');

    
end