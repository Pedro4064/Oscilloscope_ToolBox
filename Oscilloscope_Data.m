classdef Oscilloscope_Data

    properties 
        record_length
        sample_interval
        trigger_point
        source
        vertical_units
        vertical_offset
        horizontal_units
        horizontal_scale
        probe_attenuation
        model_number
        serial_number
        firmware_version
        time
        readings
    end

    methods
        function obj = Oscilloscope_Data(path_to_root_file, channel_names)
            % First we need to list all files in the dir and read all *CH{1..4}.csv file
            data_files = dir(path_to_root_file+"/*CH*.csv");
            data_files = struct2table(data_files);

            % Now we need to check if the channel names were passed, if not get default names
            if nargin < 2
                channel_names = obj.get_channel_names(data_files);
            end 

            % Read the first file to first populate the table
            ch_1_data = Oscilloscope_Data.read_csv_file(path_to_root_file + "/"+data_files.name{1});
            obj.record_length = Oscilloscope_Data.get_configuration_value(ch_1_data, "Record Lenght");
            obj.sample_interval = Oscilloscope_Data.get_configuration_value(ch_1_data, "Sample Interval");
            obj.trigger_point = Oscilloscope_Data.get_configuration_value(ch_1_data, "Trigger Point");
            obj.source = Oscilloscope_Data.get_configuration_value(ch_1_data, "Source");
            obj.vertical_units = Oscilloscope_Data.get_configuration_value(ch_1_data, "Vertical Units");
            obj.vertical_offset = Oscilloscope_Data.get_configuration_value(ch_1_data, "Vertical Offset");
            obj.horizontal_units = Oscilloscope_Data.get_configuration_value(ch_1_data, "Horizontal Units");
            obj.horizontal_scale = Oscilloscope_Data.get_configuration_value(ch_1_data, "Horizontal Scale");
            obj.probe_attenuation = Oscilloscope_Data.get_configuration_value(ch_1_data, "Probe Attenuation");
            obj.model_number = Oscilloscope_Data.get_configuration_value(ch_1_data, "Model Number");
            obj.serial_number = Oscilloscope_Data.get_configuration_value(ch_1_data, "Serial Number");
            obj.firmware_version = Oscilloscope_Data.get_configuration_value(ch_1_data, "Firmware Version");

            obj.readings = table();
            obj.readings.(channel_names{1}) = ch_1_data.Readings;
            obj.time = ch_1_data.Time;

            % Now iterate over the rest of the given data files
            for index = 2:height(data_files)
                data = Oscilloscope_Data.read_csv_file(path_to_root_file + "/" + data_files.name{index});
                obj.readings.(channel_names{index}) = data.Readings;
            end
 
        end

        function add_channel_data(obj, channel_name, data_file)
            data = Oscilloscope_Data.read_csv_file(data_file);
            obj.readings.(channel_name) = data.Readings;
        end

        function current_figure = plot(obj)
            clf; hold all;
            
            for data_entry = obj.readings.Properties.VariableNames
                plot(obj.time, obj.readings.(data_entry{1}));
                hold on;

            end

            legend(obj.readings.Properties.VariableNames);
            current_figure = gcf;
        end
    end

    methods (Access = private)
        function channel_names = get_channel_names(~, dir_listing)
            % First pre-allocate the cell array to store the channel names
            channel_names = cell(1, height(dir_listing));

            % Iterate over the names of the files and extract the channel name
            for i = 1:height(dir_listing)
                matches = regexp(dir_listing.name{i}, 'CH*[1-9]', 'match');
                channel_names(i) = matches(1);
            end
        end
    end

    methods (Static)
        function data_table = read_csv_file(file_name)
            % Read the csv file 
            data_table = readtable(file_name);

            % Delete the empty column
            data_table.Var3 = [];

            % Change the Columns Names
            data_table.Properties.VariableNames = ["Configuration Name" "Configuration Value" "Time" "Readings"];
            
        end

        function value = get_configuration_value(data, value_name)
            value = data(data.("Configuration Name") == value_name, "Configuration Value").("Configuration Value");
        end
    end
    
end