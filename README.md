![](docs/Logo.png)
# Overview
The Oscilloscope Toolbox is a toolbox to make interacting with Oscilloscope data easier on matlab. It automatically reads and parses the data files imported from a Tektronix oscilloscopes, with minimal configuration. 

The main use cases are if you need to add the wave forms read into a document/report and want to have control over how it looks (axis, labels, scale, legends, etc) and if you want to later run other signal analysis with the collected data, without the need to re-run the experiments.


# Functionality

## Methods 

### Oscilloscope_Data
```matlab
    data = Oscilloscope_Data(path_to_root_directory, channel_names)
```
This is the constructor for the Oscilloscope_Data class, which is responsible for parsing all data files in the passed directory. It has as two inputs:
|Argument Name | Description | Default Value|
|--------------|-------------|--------------|
|`path_to_root_directory` | The path to the directory the oscilloscope saved the data, normally it has the following structure: `ALL{0001-1000}`| There is no default value, it is strictly necessary, and you should not add the trailing `/`|
|`channel_names`| An array of meaningful names for each of the oscilloscope's channels | The default name is the channels names (i.e `ch1`, `ch2`,...) |

It will return an object with the following properties:

|Properties Name| Description | Data Type |
|---------------|-------------| ----------|
|`time` | The time of each reading (the x-axis on the oscilloscope)| Column Matrix|
|`readings` | The readings of each channel, disposed as a table| Table, with column names being the ones passed on constructor call or default ones (CH1, CH2, ...)|
|`record_length` | The number of data points collected | Float|
|`sample_interval` | The frequency of data sampling|Float |
|`trigger_point` | The voltage in which the oscilloscope triggers| Float|
|`source` | The name of the channel (ch1, ch2, ...)| String|
|`vertical_units` | The unit of measurement of the y-axis (normally Volts)| Char|
|`vertical_offset` | The reference level of the channel | Float|
|`horizontal_units` | The unit of measurement of the x-axis (normally Seconds)| Char |
|`horizontal_scale` | The time scale on the oscilloscope| Float|
|`probe_attenuation` | The attenuation of the test probe, normally either `1x` or `100x` | Float |
|`model_number` | The oscilloscope's model number| String|
|`serial_number` | The oscilloscope's serial number| String |
|`firmware_version` | The oscilloscope's firmware number| String|

### add_channel_data
```matlab
data.add_channel_data(channel_name, data_file);
```

Some times, due to the limited number of channels in the scope you might need to change one probe from one node to another, and repeat the measurements (but with the same settings regarding time scales) so you can compare the waveforms. For situations like that you can use this method, which takes as arguments the new channel_name (mandatory) and the path  to the `.csv` file. This will add another column in the `readings` table.

### plot
```matlab
data.plot();
```

This method iterates over all the channel columns from the `reading` table and plots them one over another. At the end it still has `hold on`, so any change can be applied to the graph (like title, grid on, legend, etc).

## Examples

All Examples will be using the data located in `docs/example_data`.

### Simple Plotting
```matlab
data = Oscilloscope_Data('docs/example_data/reading_1', {'Nó 1' 'Nó 2'});
data.plot();
title("Full Bridge Rectifier");
xlabel('Seconds (s)'); 
ylabel('Volts (V)');
```

Which will result in the figure bellow:

![](/docs/plots/Full_Bridge_2_Nodes.png)


### Plotting with Default Channel Names
```matlab
data = Oscilloscope_Data('docs/example_data/reading_1');
data.plot();
title("Full Bridge Rectifier");
xlabel('Seconds (s)'); 
ylabel('Volts (V)');
```

Which will result in the figure bellow:
![](/docs/plots/Full_Bridge_2_Default_Nodes.png)

### Adding Extra Channel Data
In this example we will be adding another plot, so we can show how you can plot using the data and normal plotting function, and not only the method we implemented in the class. This might be useful specially if you want to have sub-plots, etc.
```matlab
% Initialize the object and add channel
data = Oscilloscope_Data('docs/example_data/reading_1', {'Node 1' 'Node 2'});
data.add_channel_data('Full Bridge Exit', 'docs/example_data/reading_2/F0001CH2.csv');

% Add first subplot
subplot(2, 1, 1);
plot(data.time, data.readings.("Node 1"), data.time, data.readings.("Node 2"));
title("Full Bridge Rectifier Circuit");
subtitle("Half Rectifier Nodes");
legend("Node 1", "Node 2");
grid on;

% Add second subplot
subplot(2, 1, 2);
plot(data.time, data.readings.("Full Bridge Exit"));
subtitle("Full Bridge Exit Node");
legend("Node 3");
grid on;
```

Which will result in the following plot:

![](/docs/plots/Full_Bridge_3_Nodes.png)

# Oscilloscope 

## SetUp
First and foremost we need to setup the oscilloscope to save to the flash drive all the data points recorded. To do that we can configure it to flash the data whenever we press the "print" button.

To setup first press the utility button, ... ADD DESCRIPTION LATTER

# MatLab 

##  SetUp
To use the toolbox you can either :

1. Clone the repository: 
    - First you need to clone this repository by typing, on the command line: 
    ```bash
    git clone https://github.com/Pedro4064/Oscilloscope_ToolBox.git
    ```

    - Then we you need to change into the cloned directory and move the `Oscilloscope_Data.m` file to the directory you are working at (where you are writing you live script, or matlab script file).

2. Download the `Oscilloscope_Data.m` file:
    - You can access the [Oscilloscope_Data.m](https://raw.githubusercontent.com/Pedro4064/Oscilloscope_ToolBox/master/Oscilloscope_Data.m) file directly and press Cmd+s (if on Mac) or Ctrl+s (if on Windows/Linux) and save the file with the name `Oscilloscope_Data.m`, making sure to same with the `.m` extension.

    - Another possibility is to use the command line, already in the working directory, by using:
    ```bash
    curl https://raw.githubusercontent.com/Pedro4064/Oscilloscope_ToolBox/master/Oscilloscope_Data.m > Oscilloscope_Data.m
    ```


# To Do