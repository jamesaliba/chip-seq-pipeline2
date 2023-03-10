version 1.0
import '../../../chip.wdl' as chip
import 'compare_md5sum.wdl' as compare_md5sum

workflow test_xcor {
    input {
        Int xcor_subsample
        Int xcor_subsample_default = 15000000

        String pe_ta
        String se_ta

        String ref_pe_xcor_log
        String ref_pe_xcor_log_subsample
        String ref_se_xcor_log
        String ref_se_xcor_log_subsample
        String mito_chr_name = 'chrM'
        String docker
    }
    RuntimeEnvironment runtime_environment = {
        "docker": docker,
        "singularity": "",
        "conda": ""
    }
    Int xcor_cpu = 1
    Float xcor_mem_factor = 0.0
    Int xcor_time_hr = 24
    Float xcor_disk_factor = 4.5

    call chip.xcor as pe_xcor { input :
        ta = pe_ta,
        subsample = xcor_subsample_default,
        paired_end = true,
        mito_chr_name = mito_chr_name,

        cpu = xcor_cpu,
        mem_factor = xcor_mem_factor,
        time_hr = xcor_time_hr,
        disk_factor = xcor_disk_factor,
        runtime_environment = runtime_environment,
    }
    call chip.xcor as pe_xcor_subsample { input :
        ta = pe_ta,
        subsample = xcor_subsample,
        paired_end = true,
        mito_chr_name = mito_chr_name,

        cpu = xcor_cpu,
        mem_factor = xcor_mem_factor,
        time_hr = xcor_time_hr,
        disk_factor = xcor_disk_factor,
        runtime_environment = runtime_environment,
    }
    call chip.xcor as se_xcor { input :
        ta = se_ta,
        subsample = xcor_subsample_default,
        paired_end = false,
        mito_chr_name = mito_chr_name,

        cpu = xcor_cpu,
        mem_factor = xcor_mem_factor,
        time_hr = xcor_time_hr,
        disk_factor = xcor_disk_factor,
        runtime_environment = runtime_environment,
    }
    call chip.xcor as se_xcor_subsample { input :
        ta = se_ta,
        subsample = xcor_subsample,
        paired_end = false,
        mito_chr_name = mito_chr_name,

        cpu = xcor_cpu,
        mem_factor = xcor_mem_factor,
        time_hr = xcor_time_hr,
        disk_factor = xcor_disk_factor,
        runtime_environment = runtime_environment,
    }

    call compare_md5sum.compare_md5sum { input :
        labels = [
            'pe_xcor',
            'pe_xcor_subsample',
            'se_xcor',
            'se_xcor_subsample',
        ],
        files = [
            pe_xcor.score,
            pe_xcor_subsample.score,
            se_xcor.score,
            se_xcor_subsample.score,
        ],
        ref_files = [
            ref_pe_xcor_log,
            ref_pe_xcor_log_subsample,
            ref_se_xcor_log,
            ref_se_xcor_log_subsample,
        ],
    }
}
