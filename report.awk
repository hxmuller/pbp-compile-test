#!/usr/bin/awk -f
function abs ( value ) {
    ret = value;
    if ( value < 0 ) {
	ret = value * -1;
    }
    return ret;
}

{
    Tdiff = abs($2 - $3);
    Tgpu_sum += $2;
    Tsoc_sum += $3;
    Tdiff_sum += Tdiff;
    Vbat_sum += $10;
    # Store initial temperature values
    if ( NR == 1 ) {
	Tgpu_begin = $2;
	Tsoc_begin = $3;
	Vbat_begin = $10;
	Tdiff_begin = Tdiff;
	Tgpu_lo = $2;
	Tsoc_lo = $3;
	Vbat_lo = $10;
    }
    # Test for high value, store if true
    if ( $2 > Tgpu_hi ) {
	Tgpu_hi = $2;
    }
    if ( $3 > Tsoc_hi ) {
	Tsoc_hi = $3;
    }
    if ( Tdiff > Tdiff_hi ) {
	Tdiff_hi = Tdiff;
    }
    if ( $10 > Vbat_hi ) {
	Vbat_hi = $10;
    }
    # Test for lo value, store if true
    if ( $2 < Tgpu_lo ) {
	Tgpu_lo = $2;
    }
    if ( $3 < Tsoc_lo ) {
	Tsoc_lo = $3;
    }
    if ( Tdiff < Tdiff_lo ) {
	Tdiff_lo = Tdiff;
    }
    if ( $10 < Vbat_lo ) {
	Vbat_lo = $10;
    }
}
END { 
    # print beginning values
    printf("%11s %4.1f", "Tgpu_begin:", Tgpu_begin / 1000);
    printf("%13s %4.1f", "Tsoc_begin:", Tsoc_begin / 1000);
    printf("%14s %4.1f", "Tdiff_begin:", Tdiff_begin / 1000);
    printf("%13s %3.1f\n", "Vbat_begin:", Vbat_begin / 1000000);
    # print ending values
    printf("%11s %4.1f", "Tgpu_end:", $2 / 1000);
    printf("%13s %4.1f", "Tsoc_end:", $3 / 1000);
    printf("%14s %4.1f", "Tdiff_end:", Tdiff / 1000);
    printf("%13s %3.1f\n", "Vbat_end:", $10 / 1000000);
    # print hi values
    printf("%11s %4.1f", "Tgpu_hi:", Tgpu_hi / 1000);
    printf("%13s %4.1f", "Tsoc_hi:", Tsoc_hi / 1000);
    printf("%14s %4.1f", "Tdiff_hi:", Tdiff_hi / 1000);
    printf("%13s %3.1f\n", "Vbat_hi:", Vbat_hi / 1000000);
    # print lo values
    printf("%11s %4.1f", "Tgpu_lo:", Tgpu_lo / 1000);
    printf("%13s %4.1f", "Tsoc_lo:", Tsoc_lo / 1000);
    printf("%14s %4.1f", "Tdiff_lo:", Tdiff_lo / 1000);
    printf("%13s %3.1f\n", "Vbat_lo:", Vbat_lo / 1000000);
    # Print avg values
    printf("%11s %4.1f", "Tgpu_avg:", (Tgpu_sum / FNR) / 1000);
    printf("%13s %4.1f", "Tsoc_avg:", (Tsoc_sum / FNR) / 1000);
    printf("%14s %4.1f", "Tdiff_avg:", (Tdiff_sum / FNR) / 1000);
    printf("%13s %3.1f\n", "Vbat_avg:", (Vbat_sum / FNR) / 1000000);
}


