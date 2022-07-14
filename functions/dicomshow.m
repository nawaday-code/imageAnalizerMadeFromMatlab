function dicomshow(Input);

minimum = min(min(Input));
maximum = max(max(Input));

% imshow(Input,[minimum+(maximum-minimum)*0.1 maximum-(maximum-minimum)*0.1]);
imshow(Input,[minimum+(maximum-minimum)*0.0 maximum-(maximum-minimum)*0.05]);

end