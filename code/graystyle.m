function graystyle(axh)

% Set figure background to white
fh  = axh.Parent;
if isprop(fh,'Color')
    fh.Color = 'w';
elseif isprop(fh,'BackgroundColor')
    fh.BackgroundColor = 'w';
end


% Set axes background and edges to gray
axh.Color = ones(1,3)*0.9;
axh.XColor = axh.Color;
axh.YColor = axh.Color;
axh.ZColor = axh.Color;

% Set grid to white
axh.GridColor = 'white';
axh.GridAlpha = 1; %0.4;
axh.Layer = 'bottom';
grid(axh,'on');

% Set ticks and box
axh.TickDir = 'out';
axh.TickLength = [0.005 0.012];
axh.Box = 'off';

% Set TickLabels color to gray
axh.XAxis.TickLabelFormat = '\\color\[rgb\]\{0.5,0.5,0.5\} %g';
axh.YAxis.TickLabelFormat = axh.XAxis.TickLabelFormat;
axh.ZAxis.TickLabelFormat = axh.XAxis.TickLabelFormat;

% Set label colors to same colors as TickLabels
axh.XLabel.Color = ones(1,3)*0.4;
axh.YLabel.Color = axh.XLabel.Color;
axh.ZLabel.Color = axh.XLabel.Color;

% Set legend
lh = legend(axh,'hide');
lh.EdgeColor = [1 1 1];


% Set Linewidth for children
if ~isempty(axh.Children)
    set(axh.Children, 'LineWidth',1.5)
end

end
 