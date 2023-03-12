classdef TDTools
    %3DTOOLS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
     methods(Static, Access = protected)
        function fig = p_create_axis(F, s)

            A = F;
            R = TransformGenerator.separateHomogeneous(F);
            x = A(1:3, 1);
            y = A(1:3, 2);
            z = A(1:3, 3);
            
            d = A(1:3, 4);
            
            d = d;


            line([d(1) d(1)+x(1)], [d(2) d(2)+x(2)], [d(3) d(3)+x(3)], 'color', 'r', 'LineWidth', 5);
            line([d(1) d(1)+y(1)], [d(2) d(2)+y(2)], [d(3) d(3)+y(3)], 'color', 'g', 'LineWidth', 5);
            line([d(1) d(1)+z(1)], [d(2) d(2)+z(2)], [d(3) d(3)+z(3)], 'color', 'b', 'LineWidth', 5);
            if(strlength(s) > 0)
                t = sprintf("(%d, %d, %d): %s", d(1), d(2), d(3), s);

            else
                t = sprintf("(%d, %d, %d)", d(1), d(2), d(3));

            end
            text(d(1), d(2), d(3)-0.2, t);
        end

        function fig = p_draw_arrow(F, xs, ys, zs, s)

            [R, D] = TransformGenerator.separateHomogeneous(F);
            dir = R * [xs(2); ys(2); zs(2)];
            quiver3(xs(1), ys(1), zs(1), dir(1), dir(2), dir(3),  1, 'LineWidth', 2)

            if(strlength(s) > 0)
                mx = (xs(2) - xs(1)) / 2;
                my = (ys(2) - ys(1)) / 2;
                mz = (zs(2) - zs(1)) / 2;
                
                text(mx, my, mz, sprintf("%s",s));
            end
        end
    end
    methods(Static)
        function fig = create_axis(varargin)
            if nargin == 1
                f = varargin{1};
                s = "";
            elseif nargin == 2
                s = varargin{2};
                f = varargin{1};
            end
            

            TDTools.p_create_axis(f, s);

        end

        function create_arrow(varargin)

            if(nargin == 3)
                F = varargin{1};
                vs = varargin{2};
                ve = varargin{3};
                TDTools.p_draw_arrow(F, [vs(1) ve(1)], [vs(2) ve(2)], [vs(3) ve(3)], "")

            
            elseif(nargin == 4)
                F = varargin{1};
                vs = varargin{2};
                ve = varargin{3};
                s = varargin{4};
                TDTools.p_draw_arrow(F, [vs(1) ve(1)], [vs(2) ve(2)], [vs(3) ve(3)], s)

            end
        end
    end
   
end

