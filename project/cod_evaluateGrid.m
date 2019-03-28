% hyper-parameters
ObjectTrainingSize = [16 16; 24 24];
NegativeSamplesFactor = [1; 2];
NumCascadeStages = [5; 7];
FalseAlarmRate = [0.3; 0.5; 0.7];
TruePositiveRate = [0.9; 0.95];
FeatureType = ['HOG'];

max_idx = [size(ObjectTrainingSize, 1) + 1; size(NegativeSamplesFactor, 1); ...
        size(NumCascadeStages, 1); size(FalseAlarmRate, 1); ...
        size(TruePositiveRate, 1); size(FeatureType, 1)];
idx = ones(size(max_idx));

test_labels = load('data/test/Selected/labels.mat');
ImageFilename = test_labels.labels.imageFilename;
bboxes = test_labels.labels.letter;

quality = zeros(prod(max_idx), length(ImageFilename));
idx_i = 1;
while idx(1) <= max_idx(1)
    if idx(1) ~= max_idx(1)
        ots = ObjectTrainingSize(idx(1),:);
        ots_str = [num2str(ots(1)) 'x' num2str(ots(2))];
    else
        ots = 'Auto';
        ots_str = ots;
    end
    nsf = NegativeSamplesFactor(idx(2));
    ncs = NumCascadeStages(idx(3));
    far = FalseAlarmRate(idx(4));
    trr = TruePositiveRate(idx(5));
    ft = FeatureType(idx(6), :);
    
    filename = ['Detectors/GridSearch/cod_detector_' ots_str '_' num2str(nsf) ...
            '_' num2str(ncs) '_' num2str(far) '_' num2str(trr) '_' ft '.xml'];
        
    detector = vision.CascadeObjectDetector(filename);
    
    for i = 1:length(ImageFilename)
        bbs_correct = bboxes{i};
        bbs = detector(imread(ImageFilename{i}));
        overlap_ratios = zeros(size(bbs_correct, 1), 1);
        sums = zeros(size(bbs_correct, 1), 1);
        j = 1;
        while size(bbs, 1) >= 1 && j <= size(bbs_correct, 1)
            overlaps = zeros(size(bbs, 1), 1);
            for k = 1:size(bbs, 1)
                overlaps(k) = bboxOverlapRatio(bbs_correct(j,:), bbs(k,:));
            end
            [o, m] = max(overlaps);
            overlap_ratios(j) = o;
            bb = bbs(m,:);
            sums(j) = prod(bbs_correct(j,3:4), 2) + prod(bbs(k,3:4), 2);
            bbs(m,:) = [];
            j = j + 1;
        end
        
        cuts = sums./(1+1./overlap_ratios);
        unions = sums./(1-overlap_ratios);
        quality(idx_i, i) = sum(cuts)/sum(unions);
    end
    
    fprintf("Finished evaluating detector %s\n", filename);
    disp(quality(idx_i, :))
    
    i = size(idx, 1);
    while idx(i) == max_idx(i)
        idx(i) = 1;
        i = i - 1;
    end
    idx(i) = idx(i) + 1;
    idx_i = idx_i + 1;
end