package {{ current_package }}.{{ module }}.service.impl;

import com.alibaba.nacos.common.utils.CollectionUtils;
import com.baomidou.mybatisplus.core.toolkit.IdWorker;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import {{ current_package }}.common.common.dto.IdCommonDTO;
import {{ current_package }}.common.constant.MessageConstant;
import {{ current_package }}.common.constraint.DataResponse;
import {{ current_package }}.common.constraint.PageResult;
import {{ current_package }}.common.constraint.SuccessResponse;
import {{ current_package }}.common.enums.DeleteFlagEnum;
import {{ current_package }}.common.utils.LambdaIf;
import {{ current_package }}.{{ module }}.common.exception.BusinessException;
import {{ current_package }}.{{ module }}.convert.{{ table_name | upper_camel }}Convert;
import {{ current_package }}.{{ module }}.dao.{{ table_name | upper_camel }}Mapper;
import {{ current_package }}.{{ module }}.dto.Add{{ table_name | upper_camel }}DTO;
import {{ current_package }}.{{ module }}.dto.List{{ table_name | upper_camel }}DTO;
import {{ current_package }}.{{ module }}.dto.Page{{ table_name | upper_camel }}DTO;
import {{ current_package }}.{{ module }}.dto.Update{{ table_name | upper_camel }}DTO;
import {{ current_package }}.{{ module }}.entity.{{ table_name | upper_camel }}Entity;
import {{ current_package }}.{{ module }}.response.{{ table_name | upper_camel }}Response;
import {{ current_package }}.{{ module }}.service.I{{ table_name | upper_camel }}Service;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * {{ table_comment }} ServiceImpl
 *
 * @author {{ author }}
 * @date {{ create_date }}
 */
@Service
@RequiredArgsConstructor
public class {{ table_name | upper_camel }}ServiceImpl implements I{{ table_name | upper_camel }}Service {

    private final {{ table_name | upper_camel }}Mapper {{ table_name | lower_camel }}Mapper;

    /**
     * 新增单个{{ table_comment }}
     *
     * @param dto Add{{ table_name | upper_camel }}DTO
     * @return SuccessResponse
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public SuccessResponse add(Add{{ table_name | upper_camel }}DTO dto) {
        {{ table_name | upper_camel }}Entity entity = {{ table_name | upper_camel }}Convert.INSTANCE.to{{ table_name | upper_camel }}Entity(dto);
        entity.setId(IdWorker.getId());
        entity.setDeleteFlag(YesOrNoEnum.NO.getCode());
        LambdaIf.of({{ table_name | lower_camel }}Mapper.insert(entity) == 1)
                .endThrow(() -> new BusinessException(BusinessException.BusinessExceptionEnum.R_3030000));
        return new SuccessResponse(MessageConstant.ADD_SUCCESS);
    }

    /**
     * 删除单个{{ table_comment }}
     *
     * @param dto IdCommonDTO
     * @return SuccessResponse
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public SuccessResponse delete(IdCommonDTO dto) {
        LocalDateTime now = LocalDateTime.now();
        {{ table_name | upper_camel }}Entity entity = new {{ table_name | upper_camel }}Entity()
                .setId(dto.getId())
                .setUpdateUserId(dto.getOperatorUserId())
                .setUpdateTime(now)
                .setDeleteUserId(dto.getOperatorUserId())
                .setDeleteTime(now)
                .setDeleteFlag(DeleteFlagEnum.DELETE_FLAG_YES.getCode());
        LambdaIf.of({{ table_name | lower_camel }}Mapper.updateById(entity) > 0)
                .endThrow(() -> new BusinessException(BusinessException.BusinessExceptionEnum.R_3030002));
        return new SuccessResponse(MessageConstant.DELETE_SUCCESS);
    }

    /**
     * 更新单个{{ table_comment }}
     *
     * @param dto Update{{ table_name | upper_camel }}DTO
     * @return SuccessResponse
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public SuccessResponse update(Update{{ table_name | upper_camel }}DTO dto) {
        long count = {{ table_name | lower_camel }}Mapper.selectCount(Wrappers.<{{ table_name | upper_camel }}Entity>lambdaQuery()
                .eq({{ table_name | upper_camel }}Entity::getId, dto.getId())
                .eq({{ table_name | upper_camel }}Entity::getDeleteFlag, YesOrNoEnum.NO.getCode())
                .last("limit 1"));
        LambdaIf.of(count == 1).endThrow(() -> new BusinessException(BusinessException.BusinessExceptionEnum.R_3030003));
        {{ table_name | upper_camel }}Entity entity = {{ table_name | upper_camel }}Convert.INSTANCE.to{{ table_name | upper_camel }}Entity(dto);
        entity.setUpdateTime(LocalDateTime.now());
        LambdaIf.of({{ table_name | lower_camel }}Mapper.updateById(entity) == 1)
                .endThrow(() -> new BusinessException(BusinessException.BusinessExceptionEnum.R_3030001));
        return new SuccessResponse(MessageConstant.UPDATE_SUCCESS);
    }

    /**
     * 获取单个{{ table_comment }}
     *
     * @param id Long
     * @return DataResponse<{{ table_name | upper_camel }}Response>
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public DataResponse<{{ table_name | upper_camel }}Response> get(Long id) {
        {{ table_name | upper_camel }}Entity entity = {{ table_name | lower_camel }}Mapper.selectOne(Wrappers.<{{ table_name | upper_camel }}Entity>lambdaQuery()
                .eq({{ table_name | upper_camel }}Entity::getId, id)
                .eq({{ table_name | upper_camel }}Entity::getDeleteFlag, YesOrNoEnum.NO.getCode())
                .last("limit 1"));
        LambdaIf.ofNullable(entity).endThrow(() -> new BusinessException(BusinessException.BusinessExceptionEnum.R_3030004));
        return new DataResponse<>({{ table_name | upper_camel }}Convert.INSTANCE.to{{ table_name | upper_camel }}Response(entity));
    }

    /**
     * 获取多个{{ table_comment }}
     *
     * @param dto List{{ table_name | upper_camel }}DTO
     * @return DataResponse<List < {{ table_name | upper_camel }}Response>>
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public DataResponse<List<{{ table_name | upper_camel }}Response>> list(List{{ table_name | upper_camel }}DTO dto) {
        List<{{ table_name | upper_camel }}Entity> entityList = {{ table_name | lower_camel }}Mapper.selectList(Wrappers.<{{ table_name | upper_camel }}Entity>lambdaQuery()
                .like(StringUtils.isNotBlank(dto.getName()), {{ table_name | upper_camel }}Entity::getName, dto.getName())
                .in(CollectionUtils.isNotEmpty(dto.getRegionIdList()), {{ table_name | upper_camel }}Entity::getRegionId, dto.getRegionIdList())
                .eq(Objects.nonNull(dto.getCreateUserId()), {{ table_name | upper_camel }}Entity::getCreateUserId, dto.getCreateUserId())
                .eq(Objects.nonNull(dto.getUpdateUserId()), {{ table_name | upper_camel }}Entity::getUpdateUserId, dto.getUpdateUserId())
                .eq({{ table_name | upper_camel }}Entity::getDeleteFlag, YesOrNoEnum.NO.getCode()));
        List<{{ table_name | upper_camel }}Response> responseList = entityList.stream()
                .map({{ table_name | upper_camel }}Convert.INSTANCE::to{{ table_name | upper_camel }}Response)
                .collect(Collectors.toList());
        return new DataResponse<>(responseList);
    }

    /**
     * 分页获取多个{{ table_comment }}
     *
     * @param dto Page{{ table_name | upper_camel }}DTO
     * @return DataResponse<PageResult < {{ table_name | upper_camel }}Response>>
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public DataResponse<PageResult<{{ table_name | upper_camel }}Response>> page(Page{{ table_name | upper_camel }}DTO dto) {
        PageResult<{{ table_name | upper_camel }}Response> pageResult = new PageResult<>();
        Page<{{ table_name | upper_camel }}Entity> page = {{ table_name | lower_camel }}Mapper.selectPage(new Page<>(), Wrappers.<{{ table_name | upper_camel }}Entity>lambdaQuery()
                .like(StringUtils.isNotBlank(dto.getName()), {{ table_name | upper_camel }}Entity::getName, dto.getName())
                .in(CollectionUtils.isNotEmpty(dto.getRegionIdList()), {{ table_name | upper_camel }}Entity::getRegionId, dto.getRegionIdList())
                .eq(Objects.nonNull(dto.getCreateUserId()), {{ table_name | upper_camel }}Entity::getCreateUserId, dto.getCreateUserId())
                .eq(Objects.nonNull(dto.getUpdateUserId()), {{ table_name | upper_camel }}Entity::getUpdateUserId, dto.getUpdateUserId())
                .eq({{ table_name | upper_camel }}Entity::getDeleteFlag, YesOrNoEnum.NO.getCode()));
        List<{{ table_name | upper_camel }}Response> responseList = page.getRecords().stream()
                .map({{ table_name | upper_camel }}Convert.INSTANCE::to{{ table_name | upper_camel }}Response)
                .collect(Collectors.toList());
        pageResult.setPageData(responseList);
        pageResult.setTotalSize(BigInteger.valueOf(page.getTotal()));
        return new DataResponse<>(pageResult);
    }

}

