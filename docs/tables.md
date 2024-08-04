1. 设备类型表
```shell
描述：
id(主键，自增), device_type_name(唯一约束, 字符串类型), device_type_code(唯一约束, 字符串类型), status(删除标识 0-未删除 1-已删除，字符类型)

CREATE TABLE t_device_type (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    device_type_name VARCHAR(50) UNIQUE NOT NULL COMMENT '设备类型名称',
    device_type_code VARCHAR(50) UNIQUE NOT NULL COMMENT '设备类型代码'
    status CHAR(1) NOT NULL COMMENT '删除标识 0-未删除 1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT = '设备类型表';
```

2. 设备元数据表
```shell
描述：
id(主键，自增), device_type_code(字符串类型), device_metadata(设备元数据, text类型, JSON字符串), version(元数据版本号，非空，数字类型), status(删除标识 0-未删除 1-已删除，字符类型)

CREATE TABLE t_device_metadata (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    device_type_code VARCHAR(50) NOT NULL COMMENT '设备类型代码',
    device_metadata TEXT NOT NULL COMMENT '设备元数据，JSON字符串',
    version INT NOT NULL COMMENT '元数据版本号，非空',
    status CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0-未删除，1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT = '设备元数据表';
```
3. 设备表
```shell
描述：
id(主键，自增), device_name(唯一约束, 字符串类型), device_code(唯一约束, 字符串类型), device_type_code(字符串类型), device_info(设备信息, text类型, json字符串), version(元数据版本号，非空，数字类型), status(删除标识 0-未删除 1-已删除，字符类型)

CREATE TABLE IF NOT EXISTS t_device (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    device_name VARCHAR(100) NOT NULL COMMENT '设备名称',
    device_code VARCHAR(50) NOT NULL UNIQUE COMMENT '设备编码',
    device_type_code VARCHAR(50) NOT NULL COMMENT '设备类型代码',
    device_info TEXT NOT NULL COMMENT '设备信息，JSON格式字符串',
    version INT NOT NULL COMMENT '元数据版本号，非空',
    status CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0-未删除，1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备信息表';
```
4. 点位表
```shell
描述:
id(主键，自增), tag(字符串类型), display_name(字符串类型), device_id(字符串类型), poi_x(点位x坐标，数字类型), poi_y(点位y坐标，数字类型), poi_z(点位z坐标，数字类型), ext_data(点位扩展信息, text类型，JSON字符串), poi_type(点位类型, 字符型, 0-空间点位 1-设备点位), status(删除标识 0-未删除 1-已删除，字符类型)

CREATE TABLE IF NOT EXISTS t_point (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    tag VARCHAR(50) NOT NULL COMMENT '点位标签',
    display_name VARCHAR(50) NOT NULL COMMENT '点位显示名称',
    device_id INT COMMENT '关联的设备ID',
    poi_x DOUBLE NOT NULL COMMENT '点位X坐标',
    poi_y DOUBLE NOT NULL COMMENT '点位Y坐标',
    poi_z DOUBLE NOT NULL COMMENT '点位Z坐标',
    ext_data TEXT COMMENT '点位扩展信息，JSON格式字符串',
    poi_type CHAR(1) NOT NULL DEFAULT '0' COMMENT '点位类型，0-空间点位，1-设备点位',
    status CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0-未删除，1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点位信息表';
```