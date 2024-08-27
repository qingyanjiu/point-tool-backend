#1. 设备点位类型表
CREATE TABLE t_deivce_point_type (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    deivce_point_type_name VARCHAR(50) UNIQUE NOT NULL COMMENT '设备点位类型名称',
    deivce_point_type_code VARCHAR(50) UNIQUE NOT NULL COMMENT '设备点位类型代码',
    status CHAR(1) NOT NULL COMMENT '删除标识 0-未删除 1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT = '设备点位类型表';

#2. 设备元数据表
CREATE TABLE t_device_metadata (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    deivce_point_type INT NOT NULL COMMENT '设备类型id',
    device_metadata TEXT NOT NULL COMMENT '设备元数据，JSON字符串',
    version INT NOT NULL COMMENT '元数据版本号，非空',
    status CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0-未删除，1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT = '设备元数据表';

#3. 设备表
CREATE TABLE t_device (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    device_info TEXT NOT NULL COMMENT '设备信息，JSON格式字符串',
    t_device_metadata_id INT NOT NULL COMMENT '设备元数据id',
    status CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0-未删除，1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备表';

#4. 场景表
CREATE TABLE t_scene (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键，自增',
    scene_code VARCHAR(50) NOT NULL COMMENT '场景代码',
    scene_name VARCHAR(100) NOT NULL COMMENT '场景名称',
    scene_desc VARCHAR(100) COMMENT '场景描述',
    status CHAR(1) NOT NULL CHECK (status IN ('0', '1')) COMMENT '删除标识 0-未删除 1-已删除',
    order INT DEFAULT 0 COMMENT '排序号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='场景表';

#5. 场景内区域表
CREATE TABLE t_area (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键，自增',
    area_code VARCHAR(50) NOT NULL COMMENT '区域代码',
    area_name VARCHAR(100) NOT NULL COMMENT '区域名称',
    area_desc VARCHAR(100) COMMENT '区域描述',
    status CHAR(1) NOT NULL DEFAULT '0' CHECK (status IN ('0', '1')) COMMENT '删除标识 0-未删除 1-已删除',
    order INT DEFAULT 0 COMMENT '排序号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='场景内区域表';

#6. 点位表
CREATE TABLE t_point (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    tag VARCHAR(50) NOT NULL COMMENT '点位标签',
    display_name VARCHAR(50) NOT NULL COMMENT '点位显示名称',
    device_id INT COMMENT '本系统中的设备ID，可以为空',
    bind_device_id INT COMMENT '外部系统中的设备唯一编号，可以为空',
    poi_x DOUBLE NOT NULL COMMENT '点位X坐标',
    poi_y DOUBLE NOT NULL COMMENT '点位Y坐标',
    poi_z DOUBLE NOT NULL COMMENT '点位Z坐标',
    ext_data TEXT COMMENT '点位扩展信息，JSON格式字符串',
    poi_type CHAR(1) NOT NULL DEFAULT '0' COMMENT '点位类型，0-空间点位，1-设备点位',
    device_type_id INT DEFAULT NULL COMMENT '设备类型code，仅当poi_type为1即设备点位时才需要设置',
    scene_id INT DEFAULT NULL COMMENT '场景id',
    area_id INT DEFAULT NULL COMMENT '区域id',
    status CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0-未删除，1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点位表';

#7. 点位联动表
CREATE TABLE t_point_relation (
    main_point_id INT NOT NULL COMMENT '主点位id',
    related_point_id INT NOT NULL COMMENT '关联点位id',
    PRIMARY KEY (main_point_id, related_point_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点位联动表';

#8. 智能化专题表
CREATE TABLE t_subject (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID，自动增长',
    subject_code VARCHAR(50) NOT NULL COMMENT '专题代码',
    subject_name VARCHAR(100) NOT NULL COMMENT '专题名称',
    subject_desc VARCHAR(100) COMMENT '专题描述',
    status CHAR(1) NOT NULL DEFAULT '0' CHECK (status IN ('0', '1')) COMMENT '删除标识，0-未删除，1-已删除',
    order INT DEFAULT 0 COMMENT '排序号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能化专题表';

#9. 设备点位类型与智能化专题关联表
CREATE TABLE t_subject_device_relation (
    subject_id INT NOT NULL COMMENT '智能化专题ID',
    device_point_type_id INT NOT NULL COMMENT '设备点位类型ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备点位类型与智能化专题关联表';

#10. 第三方系统鉴权接口信息表
CREATE TABLE t_third_auth_info (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一主键，自增，INT类型',
    login_url VARCHAR(255) NOT NULL COMMENT '登录地址',
    param_str VARCHAR(100) COMMENT '登录参数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='第三方系统鉴权接口信息表';

#11. 第三方系统设备接口信息表
CREATE TABLE t_third_device_api_info (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键，INT类型，自增',
    device_point_type_id INT NOT NULL COMMENT '设备点位类型id，INT类型',
    type CHAR(1) NOT NULL COMMENT '接口类型，0-列表,1-详情',
    api_url VARCHAR(255) NOT NULL COMMENT '接口地址',
    params VARCHAR(255) COMMENT '查询参数',
    id_key VARCHAR(50) COMMENT '返回数据的设备id字段的key',
    name_key VARCHAR(50) COMMENT '返回数据的设备名称字段的key'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='第三方系统设备接口信息表';