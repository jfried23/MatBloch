classdef FitGlobalp1331
    %UNTITLED16 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pulseq;
        blochsim;
        datasets; %An array of CEST objects
        xdata;
        ydata;
    end
    
    methods
        function obj = FitGlobalp1331( ZBlochSim, ncycle, center_ppm, varargin )
            %First check user input
            %assert( isa( ZBlochSim, 'ZSpecBlochSim') );
            %assert( isa( pulseSequenc, 'PulseSequence') );
            %for data = varargin, assert( isa( data{1}, 'CEST') ); end
            obj.blochsim = ZBlochSim;
            obj.datasets = varargin;
                        
            obj.pulseq=[]
                
            %Compile global dataset into single vector
            obj.xdata=[];
            obj.ydata=[];
            i=1;
            for dataset = obj.datasets
                this_data=dataset{1};
                obj.xdata=[obj.xdata this_data.fullppm'];
                obj.ydata=[obj.ydata this_data.zspec'];
                
                if ncycle(i) == 0
                    seq = gen_cest( 1.0, this_data.B1 );
                else
                    seq = gen_p1331_7T( 1.0, this_data.B1, ncycle(i), center_ppm );
                end
                
                obj.pulseq = [obj.pulseq seq];
                i=i+1;
            end
            
        end
        
        
    function [x,f] = run( obj )
                        
            options = optimoptions('lsqcurvefit','Display','iter','MaxFunEvals', 900);
            [guess, guess_lb, guess_ub] =  obj.blochsim.get_x0;
            problem = createOptimProblem('lsqcurvefit', 'objective', @obj.eval_model , 'x0', guess, 'lb', guess_lb, 'ub', guess_ub, 'xdata', obj.xdata, 'ydata', obj.ydata, 'options', options)            
            %problem = createOptimProblem('lsqcurvefit', 'objective', @obj.eval_model , 'x0', guess, 'xdata', obj.xdata, 'ydata', obj.ydata, 'options', options)            
            
            gs = GlobalSearch;
            gs=MultiStart;
            [x,f] = run(gs,problem, 20);
            obj.blochsim.set_x0( x );
        end
        
        function obj = run_unbound_lsqcurvefit( obj )  
            options = optimoptions('lsqcurvefit','Display','iter','Algorithm','levenberg-marquardt' );
            [guess, guess_lb, guess_ub] =  obj.blochsim.get_x0;
            x = lsqcurvefit(@obj.eval_model, guess, obj.xdata, obj.ydata, [],[], options);
            obj.blochsim.set_x0( x );
        end
        
        
        function obj = run_unbound_lsqcurvefit_with_b1_opt( obj )
            options = optimoptions('lsqcurvefit','Display','iter','Algorithm','levenberg-marquardt' );
            [guess, guess_lb, guess_ub] =  obj.blochsim.get_x0;
                        
            b1s=[];
            
            i=1;
            for dataset = obj.datasets
                this_data=dataset{1};
                b1s(i) = this_data.B1;
                i=i+1;
            end
            
            x = lsqcurvefit(@obj.eval_model, guess, obj.xdata, obj.ydata, [],[], options);
            obj.blochsim.set_x0( x );
            
                        
            num_datasets = length( obj.datasets ) - 1;           
            for dataset = obj.datasets
                this_data=dataset{1};
                
                this_data.B1 = x(end - num_datasets);
                num_datasets = num_datasets - 1;
            end
            
        end
        
        
        
        function obj = run_lsqcurvefit( obj )
            options = optimoptions('lsqcurvefit','Display','iter');
            [guess, guess_lb, guess_ub] =  obj.blochsim.get_x0;
            
            x = lsqcurvefit(@obj.eval_model, guess, obj.xdata, obj.ydata, guess_lb,guess_ub, options);
            obj.blochsim.set_x0( x );
        end
        
        
        
        function obj = run_lsqcurvefit_with_b1_opt( obj )
            options = optimoptions('lsqcurvefit','Display','iter');
            [guess, guess_lb, guess_ub] =  obj.blochsim.get_x0;
            
            b1s=[];
            
            i=1;
            for dataset = obj.datasets
                this_data=dataset{1};
                b1s(i) = this_data.B1;
                i=i+1;
            end
            
            b1s_percent = b1s*.3;
            
            guess=[guess b1s];
            guess_lb = [ guess_lb (b1s-b1s_percent) ];
            guess_ub = [ guess_ub (b1s+b1s_percent) ];
            
            x = lsqcurvefit(@obj.eval_model, guess, obj.xdata, obj.ydata, guess_lb,guess_ub, options);
            obj.blochsim.set_x0( x );
            
            num_datasets = length( obj.datasets ) - 1;           
            for dataset = obj.datasets
                this_data=dataset{1};
                
                this_data.B1 = x(end - num_datasets);
                num_datasets = num_datasets - 1;
            end
            
        end
        
        
        function obj = run_sim_anneal( obj )
            options = saoptimset('Display','iter');
            
            [guess, guess_lb, guess_ub] =  obj.blochsim.get_x0;
            %x = simulannealbnd(@obj.eval_diff, guess, guess_lb, guess_ub, options);
            x = simulannealbnd(@obj.eval_diff, guess, [], [], options);
            obj.blochsim.set_x0( x );
        end
        
        
        function obj = run_sim_anneal_with_b1_opt( obj )
            options = saoptimset('Display','iter');
            
            [guess, guess_lb, guess_ub] =  obj.blochsim.get_x0;
                        
            b1s=[];
            i=1;
            for dataset = obj.datasets
                this_data=dataset{1};
                b1s(i) = this_data.B1;
                i=i+1;
            end
            
            b1s_percent = b1s*.3;
            
            guess=[guess b1s];
            guess_lb = [ guess_lb (b1s-b1s_percent) ];
            guess_ub = [ guess_ub (b1s+b1s_percent) ];
            
            
            %x = simulannealbnd(@obj.eval_diff, guess, guess_lb, guess_ub, options);
            x = simulannealbnd(@obj.eval_diff, guess, [], [], options);
            obj.blochsim.set_x0( x );
            
                        
            num_datasets = length( obj.datasets ) - 1;           
            for dataset = obj.datasets
                this_data=dataset{1};
                
                this_data.B1 = x(end - num_datasets);
                num_datasets = num_datasets - 1;
            end
        end
        
        function obj = run_ga( obj )
            options = gaoptimset('Display','iter');
            
            [guess, guess_lb, guess_ub] =  obj.blochsim.get_x0;
            x = ga(@obj.eval_diff, length(guess),options) %,[],[],[],[], guess_lb, guess_ub, options);
        end
        
        function obj = plot_data( obj )
            exp =zeros( length(obj.datasets), length(obj.datasets{1}.fullppm));
            thry=zeros( length(obj.datasets), length(obj.datasets{1}.fullppm));
            indx=1;
            for dataset = obj.datasets;
                thisdata=dataset{1};
                thry(indx,:) = obj.blochsim.run( obj.pulseq(indx), thisdata.B1, thisdata.fullppm' * 298);
                exp(indx,: ) = thisdata.zspec;
                indx=indx+1;
                %plot( thisdata.fullppm, thisdata.zspec,'o' );
                %plot( thisdata.fullppm', fit );
            end
            clf;
            plot(obj.datasets{1}.fullppm, thry); hold;
            plot(obj.datasets{1}.fullppm, exp,'o');
        end
        
        
        function err = eval_diff( obj, guess)
            zspec = obj.eval_model(guess, obj.xdata);
            err = sum((zspec - obj.ydata).^2);
        end
        
        function zspec = eval_model(obj, guess, dummy)
            zspec=[];
            
            all = obj.blochsim.set_x0( guess );
            
            if ( ~all )
                num_datasets = length( obj.datasets ) - 1;           
                for dataset = obj.datasets
                    this_data=dataset{1};
                
                    this_data.B1 = guess(end - num_datasets);
                    num_datasets = num_datasets - 1;
                end
            end
            
            i=1;
            for dataset = obj.datasets;
                thisdata=dataset{1};
                zspec= [ zspec obj.blochsim.run( obj.pulseq(i), thisdata.B1, thisdata.fullppm'*298) ];
                i=i+1;
            end

        end
        
    end
    
end

