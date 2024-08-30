1. 设备点位类型表
```shell
描述：
id(主键，自增), deivce_point_type_name(唯一约束, 字符串类型), deivce_point_type_code(唯一约束, 字符串类型), status(删除标识 0-未删除 1-已删除，字符类型)

CREATE TABLE t_deivce_point_type (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    deivce_point_type_name VARCHAR(50) UNIQUE NOT NULL COMMENT '设备点位类型名称',
    deivce_point_type_code VARCHAR(50) UNIQUE NOT NULL COMMENT '设备点位类型代码'
    status CHAR(1) NOT NULL COMMENT '删除标识 0-未删除 1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT = '设备类型表';
```

2. 设备元数据表
```shell
描述：
id(主键，自增), device_point_type_id, device_point_type_code(字符串类型), device_metadata(设备元数据, text类型, JSON字符串), version(元数据版本号，非空，数字类型), status(删除标识 0-未删除 1-已删除，字符类型)
同一种类型的设备元数据，一般来讲，在录入点位时，取最新版本的元数据作为生效数据

CREATE TABLE t_device_metadata (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    device_point_type_code INT NOT NULL COMMENT '设备类型id',
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
    device_info TEXT NOT NULL COMMENT '设备信息，JSON格式字符串',
    t_device_metadata_id INT NOT NULL COMMENT '设备元数据id',
    status CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0-未删除，1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备信息表';
```

4. 场景表
```shell
id(主键，自增), scene_code(字符串类型), scene_name(字符串类型), scene_desc(字符串类型), status(删除标识 0-未删除 1-已删除，字符类型), order(INT类型，排序号)

CREATE TABLE t_scene (
    id INT AUTO_INCREMENT PRIMARY KEY,
    scene_code VARCHAR(50) NOT NULL,
    scene_name VARCHAR(100) NOT NULL,
    scene_desc VARCHAR(100) NOT NULL,,
    status CHAR(1) NOT NULL CHECK (status IN ('0', '1')),
    order INT DEFAULT 0
);
```

5. 场景内区域表(区域可以是室内楼层或者室外场景，不做层级关系)
```shell
id(主键，自增), area_code(字符串类型), area_name(字符串类型), area_desc(字符串类型), status(删除标识 0-未删除 1-已删除，字符类型), order(INT类型，排序号)

CREATE TABLE t_area (
    id INT AUTO_INCREMENT PRIMARY KEY,
    area_code VARCHAR(50) NOT NULL,
    area_name VARCHAR(100) NOT NULL,
    area_desc VARCHAR(100),
    status CHAR(1) NOT NULL DEFAULT '0' CHECK (status IN ('0', '1')),
    order INT DEFAULT 0
);
```

6. 点位表
```shell
描述:
id(主键，自增), tag(字符串类型), display_name(字符串类型), device_id(INT类型), poi_x(点位x坐标，数字类型), poi_y(点位y坐标，数字类型), poi_z(点位z坐标，数字类型), ext_data(点位扩展信息, text类型，JSON字符串), poi_type(点位类型, 字符型, 0-空间点位 1-设备点位), status(删除标识 0-未删除 1-已删除，字符类型)

CREATE TABLE IF NOT EXISTS t_point (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符，自动递增',
    tag VARCHAR(50) NOT NULL COMMENT '点位标签',
    display_name VARCHAR(50) NOT NULL COMMENT '点位显示名称',
    device_id INT COMMENT '本系统中的设备ID，可以为空',
    bind_device_id INT COMMENT '外部系统中的设备唯一编号，可以为空',
    poi_x DOUBLE NOT NULL COMMENT '点位X坐标',
    poi_y DOUBLE NOT NULL COMMENT '点位Y坐标',
    poi_z DOUBLE NOT NULL COMMENT '点位Z坐标',
    ext_data TEXT COMMENT '点位扩展信息，JSON格式字符串，用于扩展UE和图扑点位的一些特殊数据',
    poi_type CHAR(1) NOT NULL DEFAULT '0' COMMENT '点位类型，0-空间点位，1-设备点位',
    device_type_id INT DEFAULT NULL COMMENT '设备类型code，仅当poi_type为1即设备点位时才需要设置',
    scene_id INT DEFAULT NULL COMMENT '场景id',
    area_id INT DEFAULT NULL COMMENT '区域id',
    status CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0-未删除，1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点位信息表';
```

7. 点位联动表（主点位和关联点位时多对多关系）
```shell
描述：
main_point_id(主点位id，INT类型), related_point_id(关联点位id，INT类型)

CREATE TABLE t_point_relation (
    main_point_id INT NOT NULL COMMENT '主点位id',
    related_point_id INT NOT NULL COMMENT '关联点位id',
    PRIMARY KEY (main_point_id, related_point_id)
) COMMENT='点位联动表';
```

8. 智能化专题表
```shell
描述:
id(主键，自增), subject_code(字符串类型), subject_name(字符串类型), subject_desc(INT类型), status(删除标识 0-未删除 1-已删除，字符类型), order(INT类型，排序号)

CREATE TABLE t_subject (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID，自动增长',
    subject_code VARCHAR(50) NOT NULL COMMENT '专题代码',
    subject_name VARCHAR(100) NOT NULL COMMENT '专题名称',
    subject_desc VARCHAR(100) COMMENT '专题描述',
    status CHAR(1) NOT NULL DEFAULT '0' CHECK (status IN ('0', '1')) COMMENT '删除标识，0-未删除，1-已删除',
    order INT DEFAULT 0 COMMENT '排序号'
) COMMENT='专题表';
```

9. 设备点位类型与智能化专题关联表（设备点位类型与智能化专题是多对多关系）
```shell
描述:
subject_id(INT类型), device_point_type_id(INT类型)

CREATE TABLE t_subject_device_relation (
    subject_id INT NOT NULL COMMENT '智能化专题ID',
    device_point_type_id INT NOT NULL COMMENT '设备点位类型ID'
) COMMENT='智能化专题与设备点位类型关联表';
```

10. 第三方系统鉴权接口信息表
```shell
描述:
id(唯一主键，自增，INT类型), login_url(登录地址，varchar类型), param_str(登录参数，varchar类型)

CREATE TABLE t_third_auth_info (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一主键，自增，INT类型',
    login_url VARCHAR(255) NOT NULL COMMENT '登录地址',
    param_str VARCHAR(100) COMMENT '登录参数'
) COMMENT='第三方认证信息表';

```

11. 第三方系统设备接口信息表
```shell
描述:
id(主键，INT类型，自增), device_point_type_id(设备点位类型id，INT类型), type(接口类型，0-列表,1-详情，char(1)类型), api_url(接口地址,varchar类型), params(查询参数,varchar类型), id_key(返回数据的设备id字段的key,varchar类型), name_key(返回数据的设备名称字段的key,varchar类型)

CREATE TABLE t_third_device_api_info (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键，INT类型，自增',
    device_point_type_id INT NOT NULL COMMENT '设备点位类型id，INT类型',
    type CHAR(1) NOT NULL COMMENT '接口类型，0-列表,1-详情，char(1)类型',
    api_url VARCHAR(255) NOT NULL COMMENT '接口地址，varchar类型',
    params VARCHAR(255) COMMENT '查询参数，varchar类型',
    id_key VARCHAR(50) COMMENT '返回数据的设备id字段的key，varchar类型',
    name_key VARCHAR(50) COMMENT '返回数据的设备名称字段的key，varchar类型'
) COMMENT='第三方设备API信息表';

```