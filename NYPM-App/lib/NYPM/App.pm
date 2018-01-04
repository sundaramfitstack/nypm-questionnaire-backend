package NYPM::App;
use Dancer2;
use Mail::Mailer;

set serializer => 'JSON'; # Dancer2::Serializer::JSON

# use constant DEFAULT_TO_EMAIL => 'nyp.movers@gmail.com';
# use constant DEFAULT_BCC_EMAIL => 'rob@performgrowth.com';
# use constant DEFAULT_FROM_EMAIL => 'rob@performgrowth.com';

use constant DEFAULT_TO_EMAIL => 'sundaram.fitstack@gmail.com';
use constant DEFAULT_BCC_EMAIL => 'sundaram.fitstack@gmail.com';
use constant DEFAULT_FROM_EMAIL => 'sundaram.fitstack@gmail.com';

use constant DEFAULT_SUBJECT => 'new quote request';

use constant DEFAULT_ADMIN_EMAIL => 'sundaram.fitstack@gmail.com';

our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 'title' => 'NYPM::App' };
};

post '/notify' => sub {
    
    my $subject    = DEFAULT_SUBJECT;
    my $to_email   = DEFAULT_TO_EMAIL;
    my $from_email = DEFAULT_FROM_EMAIL;
    my $bcc_email  = DEFAULT_BCC_EMAIL;

    my $payload = from_json(request->body);
    my $service_type = $payload->{'service_type'};

  	my $content = "Hello Ali,\n\n";

    $content .= "Name: " . $payload->{'name'} . "\n".
    "Email : " . $payload->{'email'} . "\n".
    "Phone : " . $payload->{'phone'} . "\n";
    
    if ($service_type eq 'home service'){
      	
      	$content .= "Service Type: Home\n".
      	"Type: " . $payload->{'home_move_type'} . "\n".
      	"Size: " . $payload->{'home_move_size'} . "\n".
      	"Date: ". $payload->{'home_move_date'} . "\n".
      	"Budget: " . $payload->{'home_move_budget'} . "\n".
      	"Source Address: " . $payload->{'home_move_source_address'} . "\n".
      	"Destination Address: " . $payload->{'home_move_destination_address'} . "\n".
      	"Additional Info: " . $payload->{'home_move_additional_info'} . "\n".
    		"\nSincerely,\nRob";
    }
    elsif ($service_type eq 'business service'){

      	$content .= "Service Type: Business\n".
      	"Type: " . $payload->{'business_move_size'} . "\n".
      	"Size: " . $payload->{'business_move_type'} . "\n".
      	"Date: " . $payload->{'business_move_date'} . "\n".
      	"Source Address: " . $payload->{'business_move_source_address'} . "\n".
      	"Destination Address: " . $payload->{'business_move_destination_address'} ."\n".
      	"Additional Info: " . $payload->{'business_move_additional_info'} . "\n".
    		"\nSincerely,\nRob";

    }
    elsif ($service_type eq 'specialty service'){

      	$content .= "Service Type: Specialty\n".
      	"Type: " . $payload->{'specialty_move_type'} . "\n".
      	"Date: " . $payload->{'specialty_move_date'} . "\n".
      	"Source Address: " . $payload->{'specialty_move_source_address'} . "\n".
      	"Destination Address: " . $payload->{'specialty_move_destination_address'} . "\n".
      	"Additional Info: " . $payload->{'specialty_move_additional_info'} . "\n".
    		"\nSincerely,\nRob";

    }
    elsif ($service_type eq 'junk removal service'){

      	$content .= "Service Type: Junk Removal\n".
      	"Type: " . $payload->{'junk_removal_type'} . "\n".
      	"Date: " . $payload->{'junk_removal_date'} . "\n".
      	"Address: " . $payload->{'junk_removal_source_address'} . "\n".
      	"Additional Info: " . $payload->{'junk_removal_additional_info'} . "\n".
    		"\nSincerely,\nRob";

    }
    else {

    	$subject    = "service type: $service_type";
    	$content    = "Received a POST from the app with unsupported service type '$service_type'.";
    	$to_email   = DEFAULT_ADMIN_EMAIL;
    	$from_email = DEFAULT_ADMIN_EMAIL;
    	$bcc_email  = DEFAULT_ADMIN_EMAIL;
    }


    my $mailer = Mail::Mailer->new('sendmail');
    if (!defined($mailer)){
        confess("Could not instantiate Mail::Mailer");
    }

    $mailer->open({To      => $to_email,
                   From    => $from_email,
                   Bcc     => $bcc_email,
                   Subject => $subject,
                  });
    
    print $mailer $content;

    $mailer->close() || confess("Couldn't send whole message: $!");

    my $response = {
      'to_email'  =>  $to_email,
      'service_type' => $service_type
    };
};


true;
