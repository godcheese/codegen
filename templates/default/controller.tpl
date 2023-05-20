package {{ current_package }}.{{ module }}.controller;

import {{ current_package }}.common.base.BaseController;
import {{ current_package }}.common.constraint.*;
import {{ current_package }}.common.convert.CommonConvert;
import {{ current_package }}.{{ module }}.convert.{{ table_name | upper_camel }}Convert;
import {{ current_package }}.{{ module }}.facade.I{{ table_name | upper_camel }}Facade;
import {{ current_package }}.{{ module }}.request.Add{{ table_name | upper_camel }}Request;
import {{ current_package }}.{{ module }}.request.List{{ table_name | upper_camel }}Request;
import {{ current_package }}.{{ module }}.request.Page{{ table_name | upper_camel }}Request;
import {{ current_package }}.{{ module }}.request.Update{{ table_name | upper_camel }}Request;
import {{ current_package }}.{{ module }}.response.{{ table_name | upper_camel }}Response;
import {{ current_package }}.{{ module }}.service.I{{ table_name | upper_camel }}Service;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * {{ table_comment }} Controller
 *
 * @author {{ author }}
 * @date {{ create_date }}
 */
@RestController
@RequiredArgsConstructor
public class {{ table_name | upper_camel }}Controller extends BaseController implements I{{ table_name | upper_camel }}Facade {

    private final I{{ table_name | upper_camel }}Service {{ table_name | lower_camel }}Service;

    /**
     * 新增单个{{ table_comment }}
     *
     * @param request Add{{ table_name | upper_camel }}Request
     * @return SuccessResponse
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public SuccessResponse add(Add{{ table_name | upper_camel }}Request request) {
        return {{ table_name | lower_camel }}Service.add({{ table_name | upper_camel }}Convert.INSTANCE.toAdd{{ table_name | upper_camel }}Dto(request));
    }

    /**
     * 删除单个{{ table_comment }}
     *
     * @param request IdCommonRequest
     * @return SuccessResponse
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public SuccessResponse delete(IdCommonRequest request) {
        return {{ table_name | lower_camel }}Service.delete(CommonConvert.INSTANCE.toIdCommonDto(request));
    }

    /**
     * 更新单个{{ table_comment }}
     *
     * @param request Update{{ table_name | upper_camel }}Request
     * @return SuccessResponse
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public SuccessResponse update(Update{{ table_name | upper_camel }}Request request) {
        return {{ table_name | lower_camel }}Service.update({{ table_name | upper_camel }}Convert.INSTANCE.toUpdate{{ table_name | upper_camel }}Dto(request));
    }

    /**
     * 获取单个{{ table_comment }}
     *
     * @param request IdRequest
     * @return DataResponse<{{ table_name | upper_camel }}Response>
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public DataResponse<{{ table_name | upper_camel }}Response> get(IdRequest request) {
        return {{ table_name | lower_camel }}Service.get(request.getId());
    }

    /**
     * 获取多个{{ table_comment }}
     *
     * @param request List{{ table_name | upper_camel }}Request
     * @return DataResponse<List < {{ table_name | upper_camel }}Response>>
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public DataResponse<List<{{ table_name | upper_camel }}Response>> list(List{{ table_name | upper_camel }}Request request) {
        return {{ table_name | lower_camel }}Service.list({{ table_name | upper_camel }}Convert.INSTANCE.toList{{ table_name | upper_camel }}Dto(request));
    }

    /**
     * 分页获取多个{{ table_comment }}
     *
     * @param request Page{{ table_name | upper_camel }}Request
     * @return DataResponse<PageResult < {{ table_name | upper_camel }}Response>>
     * @author {{ author }}
     * @date {{ create_date }}
     */
    @Override
    public DataResponse<PageResult<{{ table_name | upper_camel }}Response>> page(Page{{ table_name | upper_camel }}Request request) {
        return {{ table_name | lower_camel }}Service.page({{ table_name | upper_camel }}Convert.INSTANCE.toPage{{ table_name | upper_camel }}Dto(request));
    }

}

