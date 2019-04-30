%rosinit

%%Load the Map of the Simulation World
filePath = fullfile(fileparts(which('TurtleBotMonteCarloLocalizationExample')), 'data', 'officemap.mat');
load(filePath);
show(map);
%% Setup the Laser Sensor Model and TurtleBot Motion Model
odometryModel = robotics.OdometryMotionModel;
odometryModel.Noise = [0.2 0.2 0.2 0.2];
rangeFinderModel = robotics.LikelihoodFieldSensorModel;
rangeFinderModel.SensorLimits = [0.45 8];
rangeFinderModel.Map = map;

%Query the Transformation Tree(tf tree) in ROS.
tftree = rostf;
waitForTransform(tftree, '/base_link', '/camera_depth_frame');
sensorTransform = getTransform(tftree, '/base_link', '/camera_depth_frame');

% Get the euler rotation angles.
laserQuat = [
    sensorTransform.Transform.Rotation.W
    sensorTransform.Transform.Rotation.X
    sensorTransform.Transform.Rotation.Y 
    sensorTransform.Transform.Rotation.Z
    ];
laserRotation = quat2eul(laserQuat, 'ZYX');

% Setup the |SensorPose|, which includesthe translation along base_link's
% +X, +Y direction in meters and rotation angle along base_link's +Z axis
% in radians.
rangeFinderModel.SensorPose = [
    sensorTransform.Transform.Translation.X
    sensorTransform.Transform.Translation.Y
    laserRotation(1)
    ];

%%   Interface   for Receiving Sensor Measurements From TurtleBot and
% Sending Velocity Commands to TurtleBot.

laserSub = rossubscriber('scan');
odomSub = rossubscriber('odom');
[velPub, velMsg] = rospublisher('/mobile_base/commands/velocity', 'geometry_msgs/Twist');
%% Initialize AMCL Object
amcl = robotics.MonteCarloLocalization;
amcl.UseLidarScan = true;
amcl.MotionModel = odometryModel;
amcl.SensorModel = rangeFinderModel;
amcl.UpdateThresholds = [0.2, 0.2, 0.2];
amcl.ResamplingInterval = 1;
%% Configure AMCL Object for Localization with Initial Pose Estimate.
amcl.ParticleLimits = [500 5000];
amcl.GlobalLocalization = false;
amcl.InitialPose = ExampleHelperAMCLGazeboTruePose();
amcl.InitialCovariance = eye(3) * 0.5;
%% Setup Helper for Visualization and Driving TurtleBot.

visualizationHelper = ExampleHelperAMCLVisualization(map);
wanderHelper = ExampleHelperAMCLWanderer(laserSub, sensorTransform, velPub, velMsg);
%% Localization Procedure
numUpdates = 60;
i = 0;
while i < numUpdates
    % Receive laser scan and odometry message.
    scanMsg = receive(laserSub);
    odompose = odomSub.LatestMessage;

    % Create lidarScan object to pass to the AMCL object.
    scan = lidarScan(scanMsg);

    % For sensors that are mounted upside down,you need to reverse the
    %order of scan angle readings using 'flip' function.%

    % Compute robot 's pose [x,y,yaw] from odometry message.
    odomQuat = [
        odompose.Pose.Pose.Orientation.W
        odompose.Pose.Pose.Orientation.X
        odompose.Pose.Pose.Orientation.Y 
        odompose.Pose.Pose.Orientation.Z
        ];
    odomRotation = quat2eul(odomQuat);
    pose = [
        odompose.Pose.Pose.Position.X
        odompose.Pose.Pose.Position.Y
        odomRotation(1)
        ];
    % Update estimated robot's pose and covariance using new odometry and
    %sensor readings.
    [isUpdated, estimatedPose, estimatedCovariance] =amcl(pose, scan);
    
    %Drive robot to next pose.
    wander(wanderHelper);
    %Plot the robot's estimated pose, particles and laser scans on the map.
    if isUpdated
        i = i + 1;
        plotStep(visualizationHelper, amcl, estimatedPose, scan, i)
    end
end
%%Stop the TurtleBot and Shutdown ROS in MATLAB
stop(wanderHelper);

rosshutdown