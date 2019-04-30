function distribution()
    b = 1;
    n = 1000000;
    x = zeros(n, 1);

    function a = norm(x)
       a0 = 1/sqrt(2*pi*b*b); 
       a = a0*exp(-x*x/(2*b*b));
    end
    
    function a = f(x)
       if (x>-b) && (x<b)
        a = abs(x);
       else
        a = 0;
       end
    end

    function a = tri(x)
        a1 = 1/(sqrt(6)*b);
        a2 = abs(x)/(6*b*b);
        a = max(0, a1-a2);
    end
    

    function sample()
        maxV = tri(0);
       % maxV = b;
        
        for c = 1:n
            a = 0;
            y = 1;
            
            while(y>tri(a))
                a = unifrnd (-3*b,3*b);
                y = unifrnd (0,maxV); % if this is function abs(x)
            end
            x(c) = a;
        end
        figure('name', 'histogram auto');
        
        h = histogram(x);
        h.Normalization = 'probability';
        % h.BinWidth = 0.01;
        % histogram函数自动计算NumBins值
        % Find the bin counts
        % h.Values
        % Get bin number
        h.NumBins
    end

    sample();

end

