function [bounding_boxes] = svm_predict(model, data, bb_sizeY, bb_sizeX)

    factor_start = 1;
    factor_scale = 1.1;
    factor_rounds = 15;

    factors = zeros(factor_rounds, 1);
    factors(1) = factor_start;
    for i = 2:factor_rounds
        factors(i) = factors(i-1) / factor_scale;
    end
    
    strideYStart = 8;
    strideXStart = 8;
    
    bounding_boxes = cell(size(data, 1), 1);
    for i = 1:length(data)
        fprintf("Started testing image %d/%d.\n", i, length(data));
        fprintf("\tStarted prediction for %d scale factors.\n", factor_rounds);
        
        img = data{i};
        height = size(img, 1);
        width = size(img, 2);
        
        bbs = [];
        ps = [];
        for i_factors = 1:size(factors, 1)
            factor = factors(i_factors);
            img_size = ceil(factor * [height, width]);
            img_resized = imresize(img, img_size);
            
            strideY = ceil(factor * strideYStart);
            strideX = ceil(factor * strideXStart);
            
            m_y = 1+floor((img_size(1)-bb_sizeY)/strideY);
            m_x = 1+floor((img_size(2)-bb_sizeX)/strideX);

            % TODO maybe extend it with 1 more s.t. the bottom/left also is
            % tested completely
            top = ((1:m_y)-1) * strideY;
            left = ((1:m_x)-1) * strideX;

            fprintf("\t\tStarted prediction for scale factor %d with %d rounds.\n", i_factors, m_y*m_x);
            j = 1;
            for j_y = 1:m_y
                for j_x = 1:m_x
                    test_img = img_resized(top(j_y)+(1:bb_sizeY), left(j_x)+(1:bb_sizeX), :);
                    bb_possible = [top(j_y) left(j_x) bb_sizeY bb_sizeX] / factor;
                    [X, ~] = extractHOGFeatures(test_img);
                    [Xhyp, p] = predict(model, X);
                    if Xhyp == 1
                        bbs = [bbs; bb_possible];
                        ps = [ps; p];
                    end
                    
                    if mod(j, 500) == 0
                        fprintf("\t\t\tFinished round %d.\n", j);
                    end
                    j = j+1;
                end
            end
            
            fprintf("\t\tFinished prediction for scale factor %d.\n", i_factors);
        end
        
        
        [~, idx] = sort(ps, 'descend');
        bbs = bbs(idx,:);
        
        m = size(bbs, 1);
        take_bbs = zeros(m, 1);
        fprintf("\tStarted non-maximum suppression with %d bounding boxes.\n", m);
        for j = 1:m
            k = 1;
            overlap_found = false;
            while k<j && ~overlap_found
                if take_bbs(k) == 1 && overlapBB(bbs(j,:), bbs(k,:), 0.5)
                %if bboxOverlapRatio(bbs(j,:), bbs(k,:), 'Min') >= 0.5
                    overlap_found = true;
                end
                k = k + 1;
            end
            
            if ~overlap_found
                take_bbs(j) = 1;
            end
            
            if mod(j, 100) == 0
                fprintf("\t\tFinished non-maximum suppression for bb %d.\n", j);
            end
        end
        
        bounding_boxes{i} = bbs(take_bbs == 1,:);
    end
    
    function [overlap] = overlapBB(bb_new, bb_old, min_coverage)
        tlbr_new = bb_new + [0 0 bb_new(1) bb_new(2)];
        tlbr_old = bb_old + [0 0 bb_old(1) bb_old(2)];
        area_tl = get_area(tlbr_new(1:2), tlbr_old);
        area_br = get_area(tlbr_new(3:4), tlbr_old);
        area = area_tl + area_br;
        
        coverage = 0;
        if isempty(find(area == 0, 1))
            tlbr_cov = tlbr_old;
            for i_a = 1:4
                if area(i_a) == 2
                    j_a = mod(i_a+1, 4) + 1;
                    tlbr_cov(j_a) = tlbr_new(j_a);
                end
            end
            coverage = prod(tlbr_cov(3:4)-tlbr_cov(1:2)) / prod(bb_old(3:4));
        end
        
        overlap = min_coverage <= coverage;
    end

    function [area] = get_area(yx, tlbr)
        area = double([yx(1)<=tlbr(3) yx(2)<=tlbr(4) ...
                yx(1)>=tlbr(1) yx(2)>=tlbr(2)]);
    end
    
end