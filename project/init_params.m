function [delete_old_data_variables, delete_old_trainPos_files, delete_old_trainNeg_files, ...
        delete_old_test_files, delete_old_feature_files, delete_old_model_files] ...
        = init_params()

    % TODO group parameters into options
    
    delete_old_data_variables = true;
    
    delete_old_trainPos_files = false;
    delete_old_trainNeg_files = false;
    delete_old_test_files = true;
    
    delete_old_feature_files = false;
    delete_old_model_files = false;
    
end