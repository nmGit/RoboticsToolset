classdef TransformGenerator   
    enumeration
        X,
        Y,
        Z
    end
    methods(Static, Access = protected)
        function H = p_Rotate3(H, axis, degrees)
            [R, D] = TransformGenerator.separateHomogeneous(H);
            R_new = R*TransformGenerator.p_Rotate2(axis, degrees);
            H = TransformGenerator.Homogeneous(R_new, D);
        end
        function R = p_Rotate2(axis, rad)

            %rad = degrees * pi / 180;
            if(axis == TransformGenerator.X)
                R = [1 0            0       
                     0 cos(rad) -sin(rad)   
                     0 sin(rad) cos(rad)    
                     ];
            elseif(axis == TransformGenerator.Y)
                R = [cos(rad)   0 sin(rad) 
                     0              1 0    
                     -sin(rad)  0 cos(rad) 
                     ];
            elseif(axis == TransformGenerator.Z)
                R = [cos(rad) -sin(rad) 0 
                     sin(rad) cos(rad)  0 
                     0            0             1 
                    ];
            end
        end
        function H = p_translate4(H, x, y, z)

            [R, D] = TransformGenerator.separateHomogeneous(H);

           
            D_new = D + R*[x; y; z];
            
            H = TransformGenerator.Homogeneous(R, D_new);
            
        end
    end
    methods(Static)
        function [R, D] = separateHomogeneous(H)
            R = H(1:3, 1:3);
            D = H(1:3, 4);
        end
        function R = Rotate(varargin)
            if(nargin == 2)
                a = varargin{1};
                d = varargin{2};
                R = TransformGenerator.p_Rotate2(a,d);

            
            elseif(nargin == 3)
                h = varargin{1};
                a = varargin{2};
                d = varargin{3};
                R = TransformGenerator.p_Rotate3(h, a,d);

            end

        end

        function R = Translate(varargin)

            if(nargin == 4)
                h = varargin{1};
                x = varargin{2};
                y = varargin{3};
                z = varargin{4};
                R = TransformGenerator.p_translate4(h, x, y, z);
                
            end

        end

        function d = Translate3(x, y, z)
            d = TransformGenerator.Translate(TransformGenerator.X, x);
            d = d + TransformGenerator.Translate(TransformGenerator.Y, y);
            d = d + TransformGenerator.Translate(TransformGenerator.Z, z);
        end 

        function H = Homogeneous(R,d)
            if(isnumeric(d) == 0 || isnumeric(R) == 0)
                H = sym(zeros(4));
                H(1:3, 1:3) = sym(R(1:3, 1:3));
                H(1:3, 4) = sym(d);
                H(4,4) = sym(1);

            else
                H = zeros(4);
                H(1:3, 1:3) = R(1:3, 1:3);
                H(1:3, 4) = d;
                H(4,4) = 1;

            end
        end

        function D = DHParam(z_theta, z_d, x_a, x_theta)
            D = eye(4);

            D = TransformGenerator.Rotate(D, TransformGenerator.Z, z_theta);
            D = TransformGenerator.Translate(D, 0, 0, z_d);
            D = TransformGenerator.Translate(D, x_a, 0, 0);
            D = TransformGenerator.Rotate(D, TransformGenerator.X, x_theta);
        end
    end
end

