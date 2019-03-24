function [deleted_old_data_variables] = init()

    [delete_old_data_variables, ~,~,~,~,~] = init_params();

    clc;
    close all;
    
    if delete_old_data_variables
        clear;
    end
    
    [deleted_old_data_variables, delete_old_trainPos_files, delete_old_trainNeg_files, ...
            delete_old_test_files, delete_old_feature_files, delete_old_model_files] ...
        = init_params();
    
    [dataTrainPosFile, dataTrainNegFile, dataTestFile, featureFile, modelFile] = init_filenames();
    
    if delete_old_trainPos_files
        delete(dataTrainPosFile);
        fprintf('Deleted training data (positive examples).\n');
    end
    if delete_old_trainNeg_files
        delete(dataTrainNegFile);
        fprintf('Deleted training data (negative examples).\n');
    end
    if delete_old_test_files
        delete(dataTestFile);
        fprintf('Deleted test data.\n');
    end
    if delete_old_trainPos_files || delete_old_trainNeg_files || delete_old_feature_files
        delete(featureFile);
        fprintf('Deleted old feature file.\n');
    end
    if delete_old_trainPos_files || delete_old_trainNeg_files || delete_old_feature_files || delete_old_model_files
        delete(modelFile);
        fprintf('Deleted old model file.\n');
    end
    
end