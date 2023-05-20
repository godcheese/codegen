package {{ current_package }}.{{ module }}.service;

import {{ current_package }}.common.common.dto.IdCommonDTO;
import {{ current_package }}.common.constraint.DataResponse;
import {{ current_package }}.common.constraint.PageResult;
import {{ current_package }}.common.constraint.SuccessResponse;
import {{ current_package }}.{{ module }}.dto.Add{{ table_name | upper_camel }}DTO;
import {{ current_package }}.{{ module }}.dto.List{{ table_name | upper_camel }}DTO;
import {{ current_package }}.{{ module }}.dto.Page{{ table_name | upper_camel }}DTO;
import {{ current_package }}.{{ module }}.dto.Update{{ table_name | upper_camel }}DTO;
import {{ current_package }}.{{ module }}.response.{{ table_name | upper_camel }}Response;

import java.util.List;

/**
 * {{ table_comment }} Service
 *
 * @author {{ author }}
 * @date {{ create_date }}
 */
public interface I{{ table_name | upper_camel }}Service {

    /**
     * 新增单个{{ table_comment }}
     *
     * @param dto Add{{ table_name | upper_camel }}DTO
     * @return SuccessResponse
     * @author {{ author }}
     * @date {{ create_date }}
     */
    SuccessResponse add(Add{{ table_name | upper_camel }}DTO dto);

    /**
     * 删除单个{{ table_comment }}
     *
     * @param dto IdCommonDTO
     * @return SuccessResponse
     * @author {{ author }}
     * @date {{ create_date }}
     */
    SuccessResponse delete(IdCommonDTO dto);

    /**
     * 更新单个{{ table_comment }}
     *
     * @param dto Update{{ table_name | upper_camel }}DTO
     * @return SuccessResponse
     * @author {{ author }}
     * @date {{ create_date }}
     */
    SuccessResponse update(Update{{ table_name | upper_camel }}DTO dto);

    /**
     * 获取单个{{ table_comment }}
     *
     * @param id Long
     * @return DataResponse<{{ table_name | upper_camel }}Response>
     * @author {{ author }}
     * @date {{ create_date }}
     */
    DataResponse<{{ table_name | upper_camel }}Response> get(Long id);

    /**
     * 获取多个{{ table_comment }}
     *
     * @param dto List{{ table_name | upper_camel }}DTO
     * @return DataResponse<List < {{ table_name | upper_camel }}Response>>
     * @author {{ author }}
     * @date {{ create_date }}
     */
    DataResponse<List<{{ table_name | upper_camel }}Response>> list(List{{ table_name | upper_camel }}DTO dto);

    /**
     * 分页获取多个{{ table_comment }}
     *
     * @param dto Page{{ table_name | upper_camel }}DTO
     * @return DataResponse<PageResult < {{ table_name | upper_camel }}Response>>
     * @author {{ author }}
     * @date {{ create_date }}
     */
    DataResponse<PageResult<{{ table_name | upper_camel }}Response>> page(Page{{ table_name | upper_camel }}DTO dto);

}

